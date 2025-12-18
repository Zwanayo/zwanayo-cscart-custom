<?php
namespace ZwaChat;

class SignatureValidator
{
    public static function isValid(string $payload, string $signature, string $appSecret): bool
    {
        if (strpos($signature, 'sha1=') !== 0) {
            return false;
        }
        $hash = substr($signature, 5);
        $expected = hash_hmac('sha1', $payload, $appSecret);
        return hash_equals($expected, $hash);
    }
}