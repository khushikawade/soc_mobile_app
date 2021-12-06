import 'package:hive/hive.dart';
part 'attributes.g.dart';

@HiveType(typeId: 1)
class Attributes {
  @HiveField(0)
	String? type;
  @HiveField(1)
	String? url;

	Attributes({this.type, this.url});

	factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
				type: json['type'] as String?,
				url: json['url'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'type': type,
				'url': url,
			};

		Attributes copyWith({
		String? type,
		String? url,
	}) {
		return Attributes(
			type: type ?? this.type,
			url: url ?? this.url,
		);
	}
}
