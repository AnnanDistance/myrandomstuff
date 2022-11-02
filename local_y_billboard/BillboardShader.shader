shader_type spatial;
render_mode unshaded;

uniform sampler2D albedo_tex;


void vertex(){
	vec3 localY = inverse(MODELVIEW_MATRIX)[1].xyz; //local y-axis of the object which will be the billboard axis.
	vec3 to_cam = inverse(WORLD_MATRIX)[2].xyz; // vector from object center to camera (I think so).
	to_cam = normalize(to_cam); //normalizing the above
	
	vec3 basisX = cross(localY,to_cam); //unit vec3 perpendicular to the plane formed by vector to cam and local Y axis
	vec3 basisZ = -1.0 * cross(localY,basisX); //unit vector pointing the way the sprite should face.
	
	mat3 bill_transform = mat3(basisX,localY,basisZ); // putting the three vectors together to form the billboard transform
	
	VERTEX = (vec4(VERTEX,1.0)*MODELVIEW_MATRIX).xyz; //removing existing object space transformation from vertices
	VERTEX = VERTEX*bill_transform; //applying the billboard transform
	
}


void fragment(){
	vec4 sample =  texture(albedo_tex,UV);
	ALBEDO =  sample.rgb;
	ALPHA = sample.a;
}

