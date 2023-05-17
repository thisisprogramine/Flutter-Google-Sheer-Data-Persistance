import 'dart:convert';

class MemberFields {
  static final String sr = 'sr';
  static final String member_number = 'member_number';
  static final String share_number = 'share_number';
  static final String registration_date = 'registration_date';
  static final String full_name = 'full_name';
  static final String adhar_number = 'adhar_number';
  static final String gender = 'gender';
  static final String address = 'address';
  static final String account_number = 'account_number';
  static final String group_number = 'group_number';
  static final String numbers_of_shares = 'numbers_of_shares';
  static final String mobile_number = 'mobile_number';

  static List<String> getFields() => [sr,
    member_number,
    share_number,
    registration_date,
    full_name,
    adhar_number,
    gender,
    address,
    account_number,
    group_number,
    numbers_of_shares,
    mobile_number
  ];
}

class Members {
  final int? sr;
  final String member_number;
  final String share_number;
  final String registration_date;
  final String full_name;
  final String adhar_number;
  final String gender;
  final String address;
  final String account_number;
  final String group_number;
  final String numbers_of_shares;
  final String mobile_number;

  const Members({
    this.sr,
    required this.member_number,
    required this.share_number,
    required this.registration_date,
    required this.full_name,
    required this.adhar_number,
    required this.gender,
    required this.address,
    required this.account_number,
    required this.group_number,
    required this.numbers_of_shares,
    required this.mobile_number,
  });

  static Members fromJson(Map<String, dynamic> json) => Members(
    sr: jsonDecode(json[MemberFields.sr]),
    member_number: json[MemberFields.member_number],
    share_number: json[MemberFields.share_number],
    registration_date: json[MemberFields.registration_date],
    full_name: json[MemberFields.full_name],
    adhar_number: json[MemberFields.adhar_number],
    gender: json[MemberFields.gender],
    address: json[MemberFields.address],
    account_number: json[MemberFields.account_number],
    group_number: json[MemberFields.group_number],
    numbers_of_shares: json[MemberFields.numbers_of_shares],
    mobile_number: json[MemberFields.mobile_number],
  );

  Members copy({
    final int? sr,
    final String? member_number,
    final String? share_number,
    final String? registration_date,
    final String? full_name,
    final String? adhar_number,
    final String? gender,
    final String? address,
    final String? account_number,
    final String? group_number,
    final String? numbers_of_shares,
    final String? mobile_number,
}) => Members(
      sr: sr ?? this.sr,
      member_number: member_number ?? this.member_number,
      share_number: share_number ?? this.share_number,
      registration_date: registration_date ?? this.registration_date,
      full_name: full_name ?? this.full_name,
      adhar_number: adhar_number ?? this.adhar_number,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      account_number: account_number ?? this.account_number,
      group_number: group_number ?? this.group_number,
      numbers_of_shares: numbers_of_shares ?? this.numbers_of_shares,
      mobile_number: mobile_number ?? this.mobile_number);

  Map<String, dynamic> toJson() => {
    MemberFields.sr: sr,
    MemberFields.member_number: member_number,
    MemberFields.share_number: share_number,
    MemberFields.registration_date: registration_date,
    MemberFields.full_name: full_name,
    MemberFields.adhar_number: adhar_number,
    MemberFields.gender: gender,
    MemberFields.address: address,
    MemberFields.account_number: account_number,
    MemberFields.group_number: group_number,
    MemberFields.numbers_of_shares: numbers_of_shares,
    MemberFields.mobile_number: mobile_number
  };
}