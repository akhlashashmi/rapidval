// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  uid: json['uid'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  selectedCategories:
      (json['selectedCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'selectedCategories': instance.selectedCategories,
      'hasCompletedOnboarding': instance.hasCompletedOnboarding,
    };
