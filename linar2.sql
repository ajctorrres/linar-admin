-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 19, 2021 at 10:30 AM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `linar2`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `id` int(6) UNSIGNED ZEROFILL NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `agent`
--

CREATE TABLE `agent` (
  `id` int(4) UNSIGNED ZEROFILL NOT NULL,
  `agent_name` varchar(255) NOT NULL,
  `agent_contact` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `book_author`
--

CREATE TABLE `book_author` (
  `item_id` int(6) UNSIGNED ZEROFILL NOT NULL,
  `book_author` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `book_author`
--

INSERT INTO `book_author` (`item_id`, `book_author`) VALUES
(100001, 'John Doerthy'),
(100001, 'Lennon Mysten'),
(100000, 'Raven Shaw'),
(100003, 'Machine Gun Kelly'),
(100003, 'CORPSE'),
(100004, 'Adora Montminy'),
(100005, 'Matt Zhang'),
(100006, 'Morgan Maxwell'),
(100007, ''),
(100008, ''),
(100009, ''),
(100010, '');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(6) UNSIGNED ZEROFILL NOT NULL,
  `client_id` int(6) UNSIGNED ZEROFILL NOT NULL,
  `item_no` int(6) UNSIGNED ZEROFILL NOT NULL,
  `quantity` int(10) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `client_id`, `item_no`, `quantity`, `is_active`) VALUES
(000012, 000003, 100004, 5, 1),
(000013, 000003, 100006, 6, 1);

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `id` int(6) UNSIGNED ZEROFILL NOT NULL,
  `client_name` varchar(255) NOT NULL,
  `client_address` varchar(255) NOT NULL,
  `client_contact_person` varchar(255) NOT NULL,
  `client_contact_no` varchar(11) NOT NULL,
  `is_approved` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `date_updated` timestamp NULL DEFAULT NULL,
  `date_deleted` timestamp NULL DEFAULT NULL,
  `client_account_password` varchar(255) NOT NULL,
  `is_first_login` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`id`, `client_name`, `client_address`, `client_contact_person`, `client_contact_no`, `is_approved`, `is_active`, `is_deleted`, `date_updated`, `date_deleted`, `client_account_password`, `is_first_login`) VALUES
(000003, 'University of San Carlos', 'Technological Center - Gov M. Cuenco Avenue', 'Berna Anreb', '09991789023', 1, 1, 0, '2021-04-22 08:50:25', NULL, '$2b$10$Qn8ntghVExOhLcL6bVz8Juc.7fd.zKi9u5VoTJjs/7iWh55WK7UCq', 0);

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `id` int(6) UNSIGNED ZEROFILL NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `item_description` varchar(2000) NOT NULL,
  `unit_price` decimal(20,2) NOT NULL,
  `item_type` char(1) NOT NULL,
  `item_img` varchar(255) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `date_deleted` timestamp NULL DEFAULT NULL,
  `date_updated` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`id`, `item_name`, `item_description`, `unit_price`, `item_type`, `item_img`, `is_deleted`, `date_deleted`, `date_updated`) VALUES
(100000, 'Murdering Last Summer', 'When a summer vacation between five best friends took a turn for the worst, they have to be on guard. One of them was sure to have killed Lionel Summer. Or were they not alone?', '250.75', 'B', '/assets/sourced/murdering.png', 0, NULL, NULL),
(100001, 'In Her Eyes', 'Darkness was all Alice ever knew until she met Cayden, the widower across the street whose life took a turn for the worst when both his daughter and wife were killed in a freak accident that left him jagged around the edges. Seeing Alice for the first tim', '900.00', 'B', '/assets/sourced/her-eyes.png', 0, NULL, NULL),
(100003, 'Daywalker', 'Punch that motherf*cker in the face. You hated what he said, right? Beat his ass, leave him at the stoplight. I know you wanted change. But nobody\'s around, so kick him again while he\'s on the ground. I\'ll never be the same. I wanna know if I tell you a secret, will you keep it?', '190.99', 'B', '/assets/sourced/daywalker.png', 0, NULL, NULL),
(100004, 'About Last Night', 'Leila didn\'t expect to run into her ex-fiance the moment she got out of an abusive relationship. Filled with grief and emotionally distraught, she spills her secrets, hoping she\'d finally be at peace. He isn\'t done with her yet, though, as every word she says hits him like a freight train. If he had known before what he knows now, would he have left her the way he did back then?', '190.00', 'B', '/assets/sourced/last-night.png', 0, NULL, NULL),
(100005, 'Journey to the Stars', 'Keeping my feet on the ground and simply looking around was interesting. But I soon found out that there\'s more to life than just staying where I am. Up here, I am invincible. I am free. I am me. Here is the story about my journey to the stars.', '500.75', 'B', '/assets/sourced/journey.png', 0, NULL, NULL),
(100006, '365 Days of Self-Love', 'Nothing in this world is perfect. Life is a bitch. Our struggles knock us down, but we are stronger than them. When the pen is mightier than the sword, the mind can sometimes be stronger than the physical. Learn to love yourself in this guide of loving yourself in 365 days.', '872.10', 'B', '/assets/sourced/self-love.png', 0, NULL, NULL),
(100007, 'Scope Us Journal (1 year)', 'A one-year subscription to the most comprehensive and most valuable collection of full-text education journals in the world. The database includes full text for nearly 520 high-quality education journals including Booklist, Education, Education Digest, Education Week, Educational Leadership, Elementary School Journal, International Journal of Early Years Education, Journal of Education, Journal of Educational Research, Journal of Learning Disabilities, Phi Delta Kappan, Primary Educator, Reading Teacher, School Library Journal, Teaching PreK-8 and many others. This database also contains more than 200 educational reports. <br>\r\nResearch Advancements in the Field of Medicine and Medical Technology in the Year 2021.', '49750.00', 'S', '/assets/sourced/medical.png', 0, NULL, NULL),
(100008, 'Robots in Lightspeed (1 Year)\r\n', 'A one-year subscription to the most comprehensive and most valuable collection of full-text education journals in the world. The database includes full text for nearly 520 high-quality education journals including Booklist, Education, Education Digest, Education Week, Educational Leadership, Elementary School Journal, International Journal of Early Years Education, Journal of Education, Journal of Educational Research, Journal of Learning Disabilities, Phi Delta Kappan, Primary Educator, Reading Teacher, School Library Journal, Teaching PreK-8 and many others. This database also contains more than 200 educational reports. <br>\r\nResearch Advancements in the field of Computer Science, Engineering, and Robotics in the Year 2021.', '49750.00', 'S', '/assets/sourced/computer.png', 0, NULL, NULL),
(100009, 'What is in the Wild Life (1 Year)', 'A one-year subscription to the most comprehensive and most valuable collection of full-text education journals in the world. The database includes full text for nearly 520 high-quality education journals including Booklist, Education, Education Digest, Education Week, Educational Leadership, Elementary School Journal, International Journal of Early Years Education, Journal of Education, Journal of Educational Research, Journal of Learning Disabilities, Phi Delta Kappan, Primary Educator, Reading Teacher, School Library Journal, Teaching PreK-8 and many others. This database also contains more than 200 educational reports. <br>\r\nResearch Advancements in the field of Biology and Environmental Sciences in the Year 2021.', '49750.00', 'S', '/assets/sourced/environment.png', 0, NULL, NULL),
(100010, 'Mathematics Advanced (1 Year)', 'A one-year subscription to the most comprehensive and most valuable collection of full-text education journals in the world. The database includes full text for nearly 520 high-quality education journals including Booklist, Education, Education Digest, Education Week, Educational Leadership, Elementary School Journal, International Journal of Early Years Education, Journal of Education, Journal of Educational Research, Journal of Learning Disabilities, Phi Delta Kappan, Primary Educator, Reading Teacher, School Library Journal, Teaching PreK-8 and many others. This database also contains more than 200 educational reports. <br>\r\nResearch Advancements in the field of Mathematics in the Year 2021.', '49750.00', 'S', '/assets/sourced/mathematics.png', 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `item_tag`
--

CREATE TABLE `item_tag` (
  `item_no` int(6) UNSIGNED ZEROFILL NOT NULL,
  `tag_id` int(3) UNSIGNED ZEROFILL NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `item_tag`
--

INSERT INTO `item_tag` (`item_no`, `tag_id`) VALUES
(100000, 905),
(100001, 900),
(100001, 915),
(100003, 900),
(100003, 905),
(100004, 901),
(100004, 915),
(100005, 910),
(100006, 912),
(100007, 908),
(100008, 908),
(100009, 908),
(100010, 909);

-- --------------------------------------------------------

--
-- Table structure for table `order_delivery`
--

CREATE TABLE `order_delivery` (
  `id` int(9) UNSIGNED ZEROFILL NOT NULL,
  `order_date_received` date NOT NULL,
  `client_id` int(6) UNSIGNED ZEROFILL NOT NULL,
  `purchase_order_no` int(9) UNSIGNED ZEROFILL NOT NULL,
  `agent_id` int(4) UNSIGNED ZEROFILL NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `order_delivery_detail`
--

CREATE TABLE `order_delivery_detail` (
  `delivery_no` int(9) UNSIGNED ZEROFILL NOT NULL,
  `item_no` int(6) UNSIGNED ZEROFILL NOT NULL,
  `qty_delivered` tinyint(6) NOT NULL,
  `total_price` decimal(6,2) NOT NULL,
  `delivery_received_by` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order`
--

CREATE TABLE `purchase_order` (
  `id` int(9) UNSIGNED ZEROFILL NOT NULL,
  `purchase_date` date NOT NULL DEFAULT current_timestamp(),
  `purchase_status` tinyint(1) NOT NULL DEFAULT 0,
  `client_id` int(6) UNSIGNED ZEROFILL NOT NULL,
  `agent_id` int(4) UNSIGNED ZEROFILL NOT NULL,
  `is_completely_delivered` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_detail`
--

CREATE TABLE `purchase_order_detail` (
  `purchase_order_no` int(9) UNSIGNED ZEROFILL NOT NULL,
  `item_id` int(6) UNSIGNED ZEROFILL NOT NULL,
  `total_qty` tinyint(6) NOT NULL,
  `total_price` decimal(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

CREATE TABLE `tag` (
  `id` int(3) UNSIGNED ZEROFILL NOT NULL,
  `tag_descript` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tag`
--

INSERT INTO `tag` (`id`, `tag_descript`) VALUES
(900, 'Fantasy'),
(901, 'Historical Fiction'),
(902, 'Contemporary Fiction'),
(904, 'Science Fiction'),
(905, 'Mystery'),
(906, 'Arts & Literature'),
(907, 'History'),
(908, 'Science'),
(909, 'Mathematics'),
(910, 'Biography / Autobiography'),
(911, 'Philosophy'),
(912, 'Manuals'),
(913, 'Filipino'),
(914, 'English'),
(915, 'Romance');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `agent`
--
ALTER TABLE `agent`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_author`
--
ALTER TABLE `book_author`
  ADD KEY `item_fk5` (`item_id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_fk` (`client_id`),
  ADD KEY `item_fk4` (`item_no`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `item_tag`
--
ALTER TABLE `item_tag`
  ADD PRIMARY KEY (`item_no`,`tag_id`),
  ADD KEY `variant_fk` (`tag_id`);

--
-- Indexes for table `order_delivery`
--
ALTER TABLE `order_delivery`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_fk3` (`client_id`),
  ADD KEY `purchase_fk2` (`purchase_order_no`),
  ADD KEY `agent_fk` (`agent_id`);

--
-- Indexes for table `order_delivery_detail`
--
ALTER TABLE `order_delivery_detail`
  ADD PRIMARY KEY (`delivery_no`),
  ADD KEY `item_fk3` (`item_no`);

--
-- Indexes for table `purchase_order`
--
ALTER TABLE `purchase_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `agent_fk` (`agent_id`),
  ADD KEY `client_fk2` (`client_id`);

--
-- Indexes for table `purchase_order_detail`
--
ALTER TABLE `purchase_order_detail`
  ADD PRIMARY KEY (`purchase_order_no`),
  ADD KEY `item_fk2` (`item_id`);

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `id` int(6) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(6) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `id` int(6) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `id` int(6) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100011;

--
-- AUTO_INCREMENT for table `purchase_order`
--
ALTER TABLE `purchase_order`
  MODIFY `id` int(9) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `id` int(3) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=916;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `book_author`
--
ALTER TABLE `book_author`
  ADD CONSTRAINT `item_fk5` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`);

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `client_fk` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `item_fk4` FOREIGN KEY (`item_no`) REFERENCES `item` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `item_tag`
--
ALTER TABLE `item_tag`
  ADD CONSTRAINT `item_fk` FOREIGN KEY (`item_no`) REFERENCES `item` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `variant_fk` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_delivery`
--
ALTER TABLE `order_delivery`
  ADD CONSTRAINT `agent_fk` FOREIGN KEY (`agent_id`) REFERENCES `agent` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `client_fk3` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `purchase_fk2` FOREIGN KEY (`purchase_order_no`) REFERENCES `purchase_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_delivery_detail`
--
ALTER TABLE `order_delivery_detail`
  ADD CONSTRAINT `delivery_fk` FOREIGN KEY (`delivery_no`) REFERENCES `order_delivery` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `item_fk3` FOREIGN KEY (`item_no`) REFERENCES `item` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `purchase_order`
--
ALTER TABLE `purchase_order`
  ADD CONSTRAINT `client_fk2` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `purchase_order_detail`
--
ALTER TABLE `purchase_order_detail`
  ADD CONSTRAINT `item_fk2` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `purchase_fk` FOREIGN KEY (`purchase_order_no`) REFERENCES `purchase_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
