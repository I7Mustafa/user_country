import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:country_picker/country_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_country/location/get_country_code_request.dart';
import 'package:user_country/model/ip_data_model.dart' as i;

part 'user_location_bloc.freezed.dart';
part 'user_location_event.dart';
part 'user_location_state.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  final GetCountryCodeRequest location;
  UserLocationBloc(this.location) : super(const _Initial()) {
    on<UserLocationEvent>(
      (event, emit) async {
        await event.map(
          started: (value) async {
            emit(const _Loading());
            final i.IpData ipData = await location.getCountryCode();
            log(ipData.toJson().toString());
            log(ipData.location!.country!.code.toString());

            final Country c = Country.parse(ipData.location!.country!.code!);
            log(c.toString());
            emit(_Loaded(c));
          },
          update: (value) {
            emit(_Loaded(value.country));
          },
        );
      },
    );
  }
}
