-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ghost_dev
-- ------------------------------------------------------
-- Server version	5.5.38-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accesstokens`
--

DROP TABLE IF EXISTS `accesstokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accesstokens` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `client_id` int(10) unsigned NOT NULL,
  `expires` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accesstokens_token_unique` (`token`),
  KEY `accesstokens_user_id_foreign` (`user_id`),
  KEY `accesstokens_client_id_foreign` (`client_id`),
  CONSTRAINT `accesstokens_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  CONSTRAINT `accesstokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accesstokens`
--

LOCK TABLES `accesstokens` WRITE;
/*!40000 ALTER TABLE `accesstokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `accesstokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_fields`
--

DROP TABLE IF EXISTS `app_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `key` varchar(150) NOT NULL,
  `value` text,
  `type` varchar(150) NOT NULL DEFAULT 'html',
  `app_id` int(10) unsigned NOT NULL,
  `relatable_id` int(10) unsigned NOT NULL,
  `relatable_type` varchar(150) NOT NULL DEFAULT 'posts',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `app_fields_app_id_foreign` (`app_id`),
  CONSTRAINT `app_fields_app_id_foreign` FOREIGN KEY (`app_id`) REFERENCES `apps` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_fields`
--

LOCK TABLES `app_fields` WRITE;
/*!40000 ALTER TABLE `app_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `app_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_settings`
--

DROP TABLE IF EXISTS `app_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `key` varchar(150) NOT NULL,
  `value` text,
  `app_id` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_settings_key_unique` (`key`),
  KEY `app_settings_app_id_foreign` (`app_id`),
  CONSTRAINT `app_settings_app_id_foreign` FOREIGN KEY (`app_id`) REFERENCES `apps` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_settings`
--

LOCK TABLES `app_settings` WRITE;
/*!40000 ALTER TABLE `app_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `app_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apps`
--

DROP TABLE IF EXISTS `apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `apps` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `version` varchar(150) NOT NULL,
  `status` varchar(150) NOT NULL DEFAULT 'inactive',
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `apps_name_unique` (`name`),
  UNIQUE KEY `apps_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apps`
--

LOCK TABLES `apps` WRITE;
/*!40000 ALTER TABLE `apps` DISABLE KEYS */;
/*!40000 ALTER TABLE `apps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `secret` varchar(150) NOT NULL,
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clients_name_unique` (`name`),
  UNIQUE KEY `clients_slug_unique` (`slug`),
  UNIQUE KEY `clients_secret_unique` (`secret`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (1,'f44b4aff-1a28-47f2-82fd-f4950bd5dae7','Ghost Admin','ghost-admin','not_available','2015-08-31 14:30:46',1,'2015-08-31 14:30:46',1);
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `name` varchar(150) NOT NULL,
  `object_type` varchar(150) NOT NULL,
  `action_type` varchar(150) NOT NULL,
  `object_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'4f98ba95-94e0-4e83-b956-252976fcbd81','Export database','db','exportContent',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(2,'6cc1dfc5-67f7-414e-80f2-5562cf2704d5','Import database','db','importContent',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(3,'74e805b1-3d76-4ac6-8bee-0bdf50f939ae','Delete all content','db','deleteAllContent',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(4,'e3fff696-a48c-42e8-8ed3-821839b65a8c','Send mail','mail','send',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(5,'93c42f1c-16b7-4007-b59e-3bfb50c7171e','Browse notifications','notification','browse',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(6,'22d1505b-4673-4ea3-9479-fc2fefa64346','Add notifications','notification','add',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(7,'9c6c65ba-272a-4b60-a993-89b3b227ab47','Delete notifications','notification','destroy',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(8,'05fb5669-a663-4373-a1a0-68d3ff4ff7c3','Browse posts','post','browse',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(9,'f5353e78-9d5e-4270-afa0-71c8666720d3','Read posts','post','read',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(10,'84bfbb92-7787-4713-b20f-c5c992927826','Edit posts','post','edit',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(11,'2fb3d296-f5c0-495f-9199-f61b1db12bc9','Add posts','post','add',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(12,'9f2f80cd-3a40-4ca6-9cda-95a75d04484b','Delete posts','post','destroy',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(13,'4b690785-874e-4db8-b928-a2c06dca5717','Browse settings','setting','browse',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(14,'06b69dc3-8c16-4573-8082-f62eb85e4f25','Read settings','setting','read',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(15,'b37ebc54-bff8-4c1b-b599-b3685a5fccf4','Edit settings','setting','edit',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(16,'6a8acc8e-5e3f-4561-ae23-b8fcdc4bd64e','Generate slugs','slug','generate',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(17,'879de333-2ab7-4cdd-bcb4-e9e594fe9b04','Browse tags','tag','browse',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(18,'cc10d7fb-f986-46f5-b559-28a62c1fcad7','Read tags','tag','read',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(19,'8c575802-1bde-4958-aa02-bfd4d0ac833b','Edit tags','tag','edit',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(20,'eb06fc34-aa1f-430e-95e8-55116ea98004','Add tags','tag','add',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(21,'4199e586-0803-466e-870c-a06c1455b6d8','Delete tags','tag','destroy',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(22,'935896e9-7e3c-4f9e-8b3d-49152290515e','Browse themes','theme','browse',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(23,'dee8511d-286c-4d41-b533-c1241a4c4c2d','Edit themes','theme','edit',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(24,'b1f3e971-86ee-4b4d-adfe-4df828cd8101','Browse users','user','browse',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(25,'b9ec0a33-8177-402f-98f5-038f67c0f6cd','Read users','user','read',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(26,'8b00f0bd-3de9-4459-8782-68ddf1bc9586','Edit users','user','edit',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(27,'60b48503-f565-4d16-88bf-94ad00dc0f7b','Add users','user','add',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(28,'8e9fa407-58cd-44f4-bfae-0d2252867eba','Delete users','user','destroy',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(29,'591a1a4f-466a-4894-87cd-15f0ac7608db','Assign a role','role','assign',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1),(30,'867caff4-e775-4f2d-97b6-414d266aea66','Browse roles','role','browse',NULL,'2015-08-31 14:30:47',1,'2015-08-31 14:30:47',1);
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions_apps`
--

DROP TABLE IF EXISTS `permissions_apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions_apps` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions_apps`
--

LOCK TABLES `permissions_apps` WRITE;
/*!40000 ALTER TABLE `permissions_apps` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions_apps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions_roles`
--

DROP TABLE IF EXISTS `permissions_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions_roles`
--

LOCK TABLES `permissions_roles` WRITE;
/*!40000 ALTER TABLE `permissions_roles` DISABLE KEYS */;
INSERT INTO `permissions_roles` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,1,7),(8,1,8),(9,1,9),(10,1,10),(11,1,11),(12,1,12),(13,1,13),(14,1,14),(15,1,15),(16,1,16),(17,1,17),(18,1,18),(19,1,19),(20,1,20),(21,1,21),(22,1,22),(23,1,23),(24,1,24),(25,1,25),(26,1,26),(27,1,27),(28,1,28),(29,1,29),(30,1,30),(31,2,8),(32,2,9),(33,2,10),(34,2,11),(35,2,12),(36,2,13),(37,2,14),(38,2,16),(39,2,17),(40,2,18),(41,2,19),(42,2,20),(43,2,21),(44,2,24),(45,2,25),(46,2,26),(47,2,27),(48,2,28),(49,2,29),(50,2,30),(51,3,8),(52,3,9),(53,3,11),(54,3,13),(55,3,14),(56,3,16),(57,3,17),(58,3,18),(59,3,20),(60,3,24),(61,3,25),(62,3,30);
/*!40000 ALTER TABLE `permissions_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions_users`
--

DROP TABLE IF EXISTS `permissions_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions_users`
--

LOCK TABLES `permissions_users` WRITE;
/*!40000 ALTER TABLE `permissions_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `title` varchar(150) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `markdown` mediumtext,
  `html` mediumtext,
  `image` text,
  `featured` tinyint(1) NOT NULL DEFAULT '0',
  `page` tinyint(1) NOT NULL DEFAULT '0',
  `status` varchar(150) NOT NULL DEFAULT 'draft',
  `language` varchar(6) NOT NULL DEFAULT 'en_US',
  `meta_title` varchar(150) DEFAULT NULL,
  `meta_description` varchar(200) DEFAULT NULL,
  `author_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `published_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `posts_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (1,'94c97394-cdab-4c97-bc4c-489fabdbd2f0','Welcome to Ghost','welcome-to-ghost','You\'re live! Nice. We\'ve put together a little post to introduce you to the Ghost editor and get you started. You can manage your content by signing in to the admin area at `<your blog URL>/ghost/`. When you arrive, you can select this post from a list on the left and see a preview of it on the right. Click the little pencil icon at the top of the preview to edit this post and read the next section!\n\n## Getting Started\n\nGhost uses something called Markdown for writing. Essentially, it\'s a shorthand way to manage your post formatting as you write!\n\nWriting in Markdown is really easy. In the left hand panel of Ghost, you simply write as you normally would. Where appropriate, you can use *shortcuts* to **style** your content. For example, a list:\n\n* Item number one\n* Item number two\n    * A nested item\n* A final item\n\nor with numbers!\n\n1. Remember to buy some milk\n2. Drink the milk\n3. Tweet that I remembered to buy the milk, and drank it\n\n### Links\n\nWant to link to a source? No problem. If you paste in a URL, like http://ghost.org - it\'ll automatically be linked up. But if you want to customise your anchor text, you can do that too! Here\'s a link to [the Ghost website](http://ghost.org). Neat.\n\n### What about Images?\n\nImages work too! Already know the URL of the image you want to include in your article? Simply paste it in like this to make it show up:\n\n![The Ghost Logo](https://ghost.org/images/ghost.png)\n\nNot sure which image you want to use yet? That\'s ok too. Leave yourself a descriptive placeholder and keep writing. Come back later and drag and drop the image in to upload:\n\n![A bowl of bananas]\n\n\n### Quoting\n\nSometimes a link isn\'t enough, you want to quote someone on what they\'ve said. Perhaps you\'ve started using a new blogging platform and feel the sudden urge to share their slogan? A quote might be just the way to do it!\n\n> Ghost - Just a blogging platform\n\n### Working with Code\n\nGot a streak of geek? We\'ve got you covered there, too. You can write inline `<code>` blocks really easily with back ticks. Want to show off something more comprehensive? 4 spaces of indentation gets you there.\n\n    .awesome-thing {\n        display: block;\n        width: 100%;\n    }\n\n### Ready for a Break? \n\nThrow 3 or more dashes down on any new line and you\'ve got yourself a fancy new divider. Aw yeah.\n\n---\n\n### Advanced Usage\n\nThere\'s one fantastic secret about Markdown. If you want, you can write plain old HTML and it\'ll still work! Very flexible.\n\n<input type=\"text\" placeholder=\"I\'m an input field!\" />\n\nThat should be enough to get you started. Have fun - and let us know what you think :)','<p>You\'re live! Nice. We\'ve put together a little post to introduce you to the Ghost editor and get you started. You can manage your content by signing in to the admin area at <code>&lt;your blog URL&gt;/ghost/</code>. When you arrive, you can select this post from a list on the left and see a preview of it on the right. Click the little pencil icon at the top of the preview to edit this post and read the next section!</p>\n\n<h2 id=\"gettingstarted\">Getting Started</h2>\n\n<p>Ghost uses something called Markdown for writing. Essentially, it\'s a shorthand way to manage your post formatting as you write!</p>\n\n<p>Writing in Markdown is really easy. In the left hand panel of Ghost, you simply write as you normally would. Where appropriate, you can use <em>shortcuts</em> to <strong>style</strong> your content. For example, a list:</p>\n\n<ul>\n<li>Item number one</li>\n<li>Item number two\n<ul><li>A nested item</li></ul></li>\n<li>A final item</li>\n</ul>\n\n<p>or with numbers!</p>\n\n<ol>\n<li>Remember to buy some milk  </li>\n<li>Drink the milk  </li>\n<li>Tweet that I remembered to buy the milk, and drank it</li>\n</ol>\n\n<h3 id=\"links\">Links</h3>\n\n<p>Want to link to a source? No problem. If you paste in a URL, like <a href=\"http://ghost.org\">http://ghost.org</a> - it\'ll automatically be linked up. But if you want to customise your anchor text, you can do that too! Here\'s a link to <a href=\"http://ghost.org\">the Ghost website</a>. Neat.</p>\n\n<h3 id=\"whataboutimages\">What about Images?</h3>\n\n<p>Images work too! Already know the URL of the image you want to include in your article? Simply paste it in like this to make it show up:</p>\n\n<p><img src=\"https://ghost.org/images/ghost.png\" alt=\"The Ghost Logo\" /></p>\n\n<p>Not sure which image you want to use yet? That\'s ok too. Leave yourself a descriptive placeholder and keep writing. Come back later and drag and drop the image in to upload:</p>\n\n<h3 id=\"quoting\">Quoting</h3>\n\n<p>Sometimes a link isn\'t enough, you want to quote someone on what they\'ve said. Perhaps you\'ve started using a new blogging platform and feel the sudden urge to share their slogan? A quote might be just the way to do it!</p>\n\n<blockquote>\n  <p>Ghost - Just a blogging platform</p>\n</blockquote>\n\n<h3 id=\"workingwithcode\">Working with Code</h3>\n\n<p>Got a streak of geek? We\'ve got you covered there, too. You can write inline <code>&lt;code&gt;</code> blocks really easily with back ticks. Want to show off something more comprehensive? 4 spaces of indentation gets you there.</p>\n\n<pre><code>.awesome-thing {\n    display: block;\n    width: 100%;\n}\n</code></pre>\n\n<h3 id=\"readyforabreak\">Ready for a Break?</h3>\n\n<p>Throw 3 or more dashes down on any new line and you\'ve got yourself a fancy new divider. Aw yeah.</p>\n\n<hr />\n\n<h3 id=\"advancedusage\">Advanced Usage</h3>\n\n<p>There\'s one fantastic secret about Markdown. If you want, you can write plain old HTML and it\'ll still work! Very flexible.</p>\n\n<p><input type=\"text\" placeholder=\"I\'m an input field!\" /></p>\n\n<p>That should be enough to get you started. Have fun - and let us know what you think :)</p>',NULL,0,0,'published','en_US',NULL,NULL,1,'2015-08-31 14:30:46',1,'2015-08-31 14:30:46',1,'2015-08-31 14:30:46',1);
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts_tags`
--

DROP TABLE IF EXISTS `posts_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts_tags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` int(10) unsigned NOT NULL,
  `tag_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `posts_tags_post_id_foreign` (`post_id`),
  KEY `posts_tags_tag_id_foreign` (`tag_id`),
  CONSTRAINT `posts_tags_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`),
  CONSTRAINT `posts_tags_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts_tags`
--

LOCK TABLES `posts_tags` WRITE;
/*!40000 ALTER TABLE `posts_tags` DISABLE KEYS */;
INSERT INTO `posts_tags` VALUES (1,1,1);
/*!40000 ALTER TABLE `posts_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refreshtokens`
--

DROP TABLE IF EXISTS `refreshtokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refreshtokens` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `client_id` int(10) unsigned NOT NULL,
  `expires` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `refreshtokens_token_unique` (`token`),
  KEY `refreshtokens_user_id_foreign` (`user_id`),
  KEY `refreshtokens_client_id_foreign` (`client_id`),
  CONSTRAINT `refreshtokens_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  CONSTRAINT `refreshtokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refreshtokens`
--

LOCK TABLES `refreshtokens` WRITE;
/*!40000 ALTER TABLE `refreshtokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `refreshtokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'7de90274-8ace-430b-90da-c90838db1728','Administrator','Administrators','2015-08-31 14:30:46',1,'2015-08-31 14:30:46',1),(2,'04c105a6-3342-4b11-b21f-8b2d74690933','Editor','Editors','2015-08-31 14:30:46',1,'2015-08-31 14:30:46',1),(3,'8fb622fa-3d70-43e2-9aa4-c70d2f767d3d','Author','Authors','2015-08-31 14:30:46',1,'2015-08-31 14:30:46',1),(4,'bf210d0d-e765-4968-977b-6670d0c1e140','Owner','Blog Owner','2015-08-31 14:30:46',1,'2015-08-31 14:30:46',1);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
INSERT INTO `roles_users` VALUES (1,4,1);
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `key` varchar(150) NOT NULL,
  `value` text,
  `type` varchar(150) NOT NULL DEFAULT 'core',
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `settings_key_unique` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'59dd1a47-4e85-4caf-9b89-6e2eebe11415','databaseVersion','003','core','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(2,'414b4f3c-cb80-4628-9051-0eee11bb4b07','dbHash','a80ddd9b-f3e5-4af0-9310-518a027e5085','core','2015-08-31 14:30:48',1,'2015-08-31 14:30:49',1),(3,'3a9c9379-1c15-4a2c-a878-a110aa12dd5f','nextUpdateCheck',NULL,'core','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(4,'c0efc6c1-6144-4957-8763-ce498c183d98','displayUpdateNotification',NULL,'core','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(5,'488953e7-af08-4d0a-9271-42ddbca76ab4','title','Ghost','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(6,'3d94c914-8957-4f9b-aaee-248b75732678','description','Just a blogging platform.','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(7,'a8cd88eb-23ff-4e70-9e09-d8822c5b7c7a','logo','','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(8,'546a186a-1698-4d0a-9b21-0bb7de990b15','cover','','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(9,'bb0ed6f1-4a09-4448-9dff-dc1331b351b0','defaultLang','en_US','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(10,'3ad78aa7-aa83-434e-a35a-3a946c2ae16a','postsPerPage','5','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(11,'3ebd9ae7-abc2-4d9f-afaa-61a27c3b5b9d','forceI18n','true','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(12,'3e2ac7a1-4b41-4fac-b2b3-216ebc14450d','permalinks','/:slug/','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(13,'94ca0337-6662-4622-9c2e-ec84fe602dcc','ghost_head','','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(14,'3082fc66-9b24-48e8-a918-06e26b644cd5','ghost_foot','','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(15,'3f9a492f-7cec-40d6-b9f9-b61539b0e5dd','labs','{}','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(16,'2f5cc171-7b9a-407b-99dc-1d4c71bf10e8','navigation','[{\"label\":\"Home\", \"url\":\"/\"}]','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(17,'56e5115a-441c-4349-b42c-c90a05c0df5a','isPrivate','false','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(18,'b7579a8d-46b2-47eb-a5b8-4e6cfd15b765','password','','blog','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(19,'829603bb-a868-4cd1-9a39-7f23337bb857','activeApps','[]','app','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1),(20,'83bcc6fc-542b-45b0-8bef-1e96ce468afc','installedApps','[]','app','2015-08-31 14:30:48',1,'2015-08-31 14:30:49',1),(21,'e4209241-eb09-4a15-bfc0-a987a41741a8','activeTheme','casper','theme','2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1);
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `image` text,
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `meta_title` varchar(150) DEFAULT NULL,
  `meta_description` varchar(200) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tags_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'6258ff01-02b8-4e88-ad4a-ea7bc1984578','Getting Started','getting-started',NULL,NULL,0,NULL,NULL,NULL,'2015-08-31 14:30:46',1,'2015-08-31 14:30:46',1);
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `name` varchar(150) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `password` varchar(60) NOT NULL,
  `email` varchar(254) NOT NULL,
  `image` text,
  `cover` text,
  `bio` varchar(200) DEFAULT NULL,
  `website` text,
  `location` text,
  `accessibility` text,
  `status` varchar(150) NOT NULL DEFAULT 'active',
  `language` varchar(6) NOT NULL DEFAULT 'en_US',
  `meta_title` varchar(150) DEFAULT NULL,
  `meta_description` varchar(200) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_slug_unique` (`slug`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'e33534bf-358d-42a4-b1c5-8a321bff6cf9','Ghost Owner','ghost-owner','2','ghost@ghost.org',NULL,NULL,NULL,NULL,NULL,NULL,'inactive','en_US',NULL,NULL,NULL,'2015-08-31 14:30:48',1,'2015-08-31 14:30:48',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-08-31 14:31:37
