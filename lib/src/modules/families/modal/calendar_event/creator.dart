class Creator {
	String? email;
	bool? self;

	Creator({this.email, this.self});

	factory Creator.fromJson(Map<String, dynamic> json) => Creator(
				email: json['email'] as String?,
				self: json['self'] as bool?,
			);

	Map<String, dynamic> toJson() => {
				'email': email,
				'self': self,
			};
}
