class ApiList {
  static String? apiUrl = "https://grow.buktor.com";
  static String? serverLink = "${apiUrl!}/api/";

  static String? login = '${serverLink!}grow/login';
  static String? logout = '${serverLink!}grow/logout';
  static String? contactlist = '${serverLink!}contacts';
  static String? grouplist = '${serverLink!}contact-groups';
  static String? allchats = '${serverLink!}grow/whatsapp/chats';
  static String? individualchats = '${serverLink!}grow/whatsapp/chats';

  static String? sendMessage = '${serverLink!}send';
  static String? sendMedia = '${serverLink!}send/media';
}

class Tokens {
  static String? basilToken = '1vyKV6uUYtjrXAoLwp9VWyzZDQKJA2TPFu1ovWUC';
  static String? nivedToken = '8iPUHyg1xpYJHqVtyzXSLQN2Kdfz5SOm2JRqPo9E';
}
