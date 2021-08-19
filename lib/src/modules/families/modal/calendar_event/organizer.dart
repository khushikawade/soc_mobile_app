class Organizer {
	String? email;
	bool? self;

	Organizer({this.email, this.self});

	factory Organizer.fromJson(Map<String, dynamic> json) => Organizer(
				email: json['email'] as String?,
				self: json['self'] as bool?,
			);

	Map<String, dynamic> toJson() => {
				'email': email,
				'self': self,
			};
}
