import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../data/property_remote_data_source.dart';
import '../data/remote_property_repository.dart';
import '../domain/property_repository.dart';

part 'property_providers.g.dart';

@riverpod
PropertyRemoteDataSource propertyRemoteDataSource(Ref ref) =>
    PropertyRemoteDataSource(ref.watch(dioProvider));

@riverpod
PropertyRepository propertyRepository(Ref ref) =>
    RemotePropertyRepository(ref.watch(propertyRemoteDataSourceProvider));
