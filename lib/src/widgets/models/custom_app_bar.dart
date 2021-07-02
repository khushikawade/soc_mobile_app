import 'package:equatable/equatable.dart';

class CustomAppBar extends Equatable {
	final dynamic leading;
	final dynamic title;
	final dynamic subtitle;
	final dynamic trailing;

	const CustomAppBar({
		this.leading,
		this.title,
		this.subtitle,
		this.trailing,
	});

	factory CustomAppBar.fromJson(Map<String, dynamic> json) {
		return CustomAppBar(
			leading: json['leading'],
			title: json['title'],
			subtitle: json['subtitle'],
			trailing: json['trailing'],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'leading': leading,
			'title': title,
			'subtitle': subtitle,
			'trailing': trailing,
		};
	}	

	CustomAppBar copyWith({
		dynamic leading,
		dynamic title,
		dynamic subtitle,
		dynamic trailing,
	}) {
		return CustomAppBar(
			leading: leading ?? this.leading,
			title: title ?? this.title,
			subtitle: subtitle ?? this.subtitle,
			trailing: trailing ?? this.trailing,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [leading, title, subtitle, trailing];
}
