// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../providers/message_database.dart';

class ServiceModel {
  final String cost;
  final String coverage;
  String serviceId;
  final String duration;
  final String description;
  final String image;
  final String name;
  final String restaurantId;
  final List<String> gallery;
  int likes;
  int comments;
  bool negociable;
  bool favorite;
  ServiceModel({
    this.favorite = false,
    required this.cost,
    required this.coverage,
    required this.serviceId,
    required this.duration,
    required this.description,
    required this.image,
    required this.name,
    required this.restaurantId,
    required this.gallery,
    required this.likes,
    required this.comments,
    required this.negociable,
  });

  ServiceModel copyWith({
    String? cost,
    String? coverage,
    String? serviceId,
    String? duration,
    String? description,
    String? image,
    String? name,
    String? restaurantId,
    List<String>? gallery,
    int? likes,
    int? comments,
    bool? negociable,
  }) {
    return ServiceModel(
      cost: cost ?? this.cost,
      coverage: coverage ?? this.coverage,
      serviceId: serviceId ?? this.serviceId,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      image: image ?? this.image,
      name: name ?? this.name,
      restaurantId: restaurantId ?? this.restaurantId,
      gallery: gallery ?? this.gallery,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      negociable: negociable ?? this.negociable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cost': cost,
      'coverage': coverage,
      'serviceId': serviceId,
      'duration': duration,
      'description': description,
      'image': image,
      'name': name,
      'restaurantId': restaurantId,
      'gallery': gallery,
      'likes': likes,
      'comments': comments,
      'negociable': negociable,
    };
  }

  factory ServiceModel.fromMap(AsyncSnapshot<DocumentSnapshot> info) {
    var favorites = DatabaseHelper.instance;
    Map<String, dynamic> map = info.data!.data()! as Map<String, dynamic>;
    String documentId = info.data!.id;

    bool isFavorite = favorites.checkFavoriteServices(foodId: documentId);

    return ServiceModel(
      favorite: isFavorite,
      cost: map['cost'] as String,
      coverage: map['coverage'] as String,
      serviceId: map['serviceId'] as String,
      duration: map['duration'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      name: map['name'] as String,
      restaurantId: map['restaurantId'] as String,
      gallery: List<String>.from(
        (map['gallery'] as List<String>),
      ),
      likes: map['likes'] as int,
      comments: map['comments'] as int,
      negociable: map['negociable'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Service(cost: $cost, coverage: $coverage, serviceId: $serviceId, duration: $duration, description: $description, image: $image, name: $name, restaurantId: $restaurantId, gallery: $gallery, likes: $likes, comments: $comments, negociable: $negociable)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceModel &&
        other.cost == cost &&
        other.coverage == coverage &&
        other.serviceId == serviceId &&
        other.duration == duration &&
        other.description == description &&
        other.image == image &&
        other.name == name &&
        other.restaurantId == restaurantId &&
        listEquals(other.gallery, gallery) &&
        other.likes == likes &&
        other.comments == comments &&
        other.negociable == negociable;
  }

  @override
  int get hashCode {
    return cost.hashCode ^
        coverage.hashCode ^
        serviceId.hashCode ^
        duration.hashCode ^
        description.hashCode ^
        image.hashCode ^
        name.hashCode ^
        restaurantId.hashCode ^
        gallery.hashCode ^
        likes.hashCode ^
        comments.hashCode ^
        negociable.hashCode;
  }
}
