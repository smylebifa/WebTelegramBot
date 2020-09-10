-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Авг 30 2020 г., 19:34
-- Версия сервера: 10.4.13-MariaDB-1:10.4.13+maria~buster
-- Версия PHP: 7.3.20-1+0~20200710.65+debian10~1.gbpc9cbeb

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `webprog1x5_tgbot`
--

-- --------------------------------------------------------

--
-- Структура таблицы `webprog1x5_tgbot_admin_id`
--

CREATE TABLE `webprog1x5_tgbot_admin_id` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'Имя администратора',
  `surname` varchar(50) NOT NULL COMMENT 'Фамилия администратора',
  `group_number` int(11) NOT NULL COMMENT 'Группа администратора'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `webprog1x5_tgbot_admin_id`
--

INSERT INTO `webprog1x5_tgbot_admin_id` (`id`, `name`, `surname`, `group_number`) VALUES
(1, 'Alexander', 'Vasiliev', 1),
(2, 'Alexander', 'Chistyakov', 2);

-- --------------------------------------------------------

--
-- Структура таблицы `webprog1x5_tgbot_group`
--

CREATE TABLE `webprog1x5_tgbot_group` (
  `id` int(11) NOT NULL,
  `group_number` int(11) NOT NULL COMMENT 'Номер группы',
  `hometask_number` int(11) NOT NULL COMMENT 'Номер задания',
  `user_id` int(11) NOT NULL COMMENT 'Номер учащегося',
  `deadline` tinyint(1) NOT NULL COMMENT 'Условие сдачи(вовремя/не вовремя)',
  `score` int(5) NOT NULL COMMENT 'Оценка'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `webprog1x5_tgbot_group`
--

INSERT INTO `webprog1x5_tgbot_group` (`id`, `group_number`, `hometask_number`, `user_id`, `deadline`, `score`) VALUES
(1, 1, 1, 1, 0, 9),
(2, 1, 1, 2, 1, 6),
(3, 1, 2, 1, 0, 8),
(4, 1, 2, 2, 0, 4),
(5, 2, 1, 3, 0, 5),
(6, 2, 1, 4, 1, 10);

-- --------------------------------------------------------

--
-- Структура таблицы `webprog1x5_tgbot_group_id`
--

CREATE TABLE `webprog1x5_tgbot_group_id` (
  `id` int(11) NOT NULL,
  `group_number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `webprog1x5_tgbot_group_id`
--

INSERT INTO `webprog1x5_tgbot_group_id` (`id`, `group_number`) VALUES
(1, 1),
(2, 2),
(617, 3);

-- --------------------------------------------------------

--
-- Структура таблицы `webprog1x5_tgbot_messages`
--

CREATE TABLE `webprog1x5_tgbot_messages` (
  `id` int(11) NOT NULL COMMENT 'Номер сообщения',
  `group_number` int(11) NOT NULL COMMENT 'Номер группы',
  `user_id` int(11) NOT NULL COMMENT 'Номер учащегося',
  `message` varchar(1000) NOT NULL COMMENT 'Сообщение учащегося'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- --------------------------------------------------------

--
-- Структура таблицы `webprog1x5_tgbot_user_id`
--

CREATE TABLE `webprog1x5_tgbot_user_id` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'Имя учащегося',
  `surname` varchar(50) NOT NULL COMMENT 'Фамилия учащегося',
  `group_number` int(11) NOT NULL COMMENT 'Номер группы'
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `webprog1x5_tgbot_user_id`
--

INSERT INTO `webprog1x5_tgbot_user_id` (`id`, `name`, `surname`, `group_number`) VALUES
(1, 'Ivan', 'Sidorov', 1),
(2, 'Andrey', 'Petrov', 1),
(3, 'Alexander', 'Vasiliev', 2),
(4, 'Andrey', 'Chistyakov', 2);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `webprog1x5_tgbot_admin_id`
--
ALTER TABLE `webprog1x5_tgbot_admin_id`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `webprog1x5_tgbot_group`
--
ALTER TABLE `webprog1x5_tgbot_group`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `group_number` (`group_number`);

--
-- Индексы таблицы `webprog1x5_tgbot_group_id`
--
ALTER TABLE `webprog1x5_tgbot_group_id`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `group_number` (`group_number`);

--
-- Индексы таблицы `webprog1x5_tgbot_messages`
--
ALTER TABLE `webprog1x5_tgbot_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `webprog1x5_tgbot_user_id`
--
ALTER TABLE `webprog1x5_tgbot_user_id`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_number` (`group_number`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `webprog1x5_tgbot_admin_id`
--
ALTER TABLE `webprog1x5_tgbot_admin_id`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `webprog1x5_tgbot_group`
--
ALTER TABLE `webprog1x5_tgbot_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `webprog1x5_tgbot_group_id`
--
ALTER TABLE `webprog1x5_tgbot_group_id`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=662;

--
-- AUTO_INCREMENT для таблицы `webprog1x5_tgbot_messages`
--
ALTER TABLE `webprog1x5_tgbot_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Номер сообщения', AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `webprog1x5_tgbot_user_id`
--
ALTER TABLE `webprog1x5_tgbot_user_id`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
