<?php
// Load the CS-Cart environment
require_once __DIR__ . '/../../bootstrap.php';

use Tygh\Registry;
use PHPUnit\Framework\TestCase;

class ZwaChatWebhookTest extends TestCase
{
    protected $secret = 'test_secret';

    protected function setUp(): void
    {
        parent::setUp();
        // Ensure debug is off to not exit early in staging mode
        Registry::set('addons.zwa_chat.debug_signature', 'N');
    }

    public function testValidSignatureAllowsProcessing()
    {
        $rawBody = '{"test":"data"}';
        $sig = 'sha1=' . hash_hmac('sha1', $rawBody, $this->secret);

        // Stub controller to return our raw body and secret
        $mock = $this->getMockBuilder(\Controller\Frontend\ZwaChat::class)
                     ->onlyMethods(['getRawInput', 'getAppSecret'])
                     ->getMock();
        $mock->method('getRawInput')->willReturn($rawBody);
        $mock->method('getAppSecret')->willReturn($this->secret);

        $_SERVER['HTTP_X_HUB_SIGNATURE'] = $sig;

        // Should not throw or exit with 403
        $response = $mock->webhookAction();
        $this->assertNotEquals(403, http_response_code());
    }

    public function testInvalidSignatureIsRejected()
    {
        $rawBody = '{"test":"data"}';
        $sig = 'sha1=invalid';

        $mock = $this->getMockBuilder(\Controller\Frontend\ZwaChat::class)
                     ->onlyMethods(['getRawInput', 'getAppSecret'])
                     ->getMock();
        $mock->method('getRawInput')->willReturn($rawBody);
        $mock->method('getAppSecret')->willReturn($this->secret);

        $_SERVER['HTTP_X_HUB_SIGNATURE'] = $sig;

        $this->expectException(\Exception::class);
        $mock->webhookAction();
    }
}
