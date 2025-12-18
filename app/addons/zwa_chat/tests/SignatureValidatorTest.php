<?php
use PHPUnit\Framework\TestCase;
use ZwaChat\SignatureValidator;

class SignatureValidatorTest extends TestCase
{
    private $secret = 'test_secret';

    public function testValidSignature()
    {
        $raw = '{"foo":"bar"}';
        $sig = 'sha1=' . hash_hmac('sha1', $raw, $this->secret);
        $this->assertTrue(SignatureValidator::isValid($raw, $sig, $this->secret));
    }

    public function testInvalidSignature()
    {
        $this->assertFalse(SignatureValidator::isValid('{"foo":"bar"}', 'sha1=invalid', $this->secret));
    }
}
