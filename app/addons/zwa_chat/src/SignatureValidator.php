<?php
namespace ZwaChat;

class SignatureValidator
{
    /**
     * @param string $rawBody   The exact request payload
     * @param string $signature The incoming X-Hub-Signature header value
     * @param string $secret    Your app secret from settings
     * @return bool             True if signatures match
     */
    public static function isValid(string $rawBody, string $signature, string $secret): bool
    {
        $expected = 'sha1=' . hash_hmac('sha1', $rawBody, $secret);
        return hash_equals($expected, $signature);
    }
}
