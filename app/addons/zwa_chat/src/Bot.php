<?php
namespace ZwaChat;

use Tygh\Registry;

if (!defined('BOOTSTRAP')) {
    die('Access denied');
}

class Bot
{
    /**
     * Handle chat API requests and return a reply.
     *
     * @param mixed $data Input data (array or JSON string) containing 'message'.
     * @return array Response array, e.g. ['reply'=>'text'] or ['error'=>'msg'].
     */
    public static function respond($data): array
    {
        // Normalize input: decode JSON string payload if necessary
        if (is_string($data)) {
            $decoded = json_decode($data, true);
            $data = is_array($decoded) ? $decoded : ['message' => $data];
        }

        $message = $data['message'] ?? '';
        if ($message === '') {
            return ['error' => 'No message provided.'];
        }

        // Get API key from settings
        $api_key = Registry::get('addons.zwa_chat.openai_api_key');
        if (empty($api_key)) {
            return ['error' => 'OpenAI API key not configured.'];
        }

        // Prepare request
        $url = 'https://api.openai.com/v1/chat/completions';
        $postData = json_encode([
            'model'    => 'gpt-3.5-turbo',
            'messages' => [
                ['role' => 'user', 'content' => $message],
            ],
        ]);

        // Initialize cURL
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Authorization: Bearer ' . $api_key,
        ]);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);

        $result = curl_exec($ch);
        if (curl_errno($ch)) {
            $error = curl_error($ch);
            curl_close($ch);
            return ['error' => 'cURL error: ' . $error];
        }
        curl_close($ch);

        $response = json_decode($result, true);
        if (!isset($response['choices'][0]['message']['content'])) {
            return ['error' => 'Invalid API response', 'raw' => $result];
        }

        $reply = $response['choices'][0]['message']['content'];
        return ['reply' => $reply];
    }
}
