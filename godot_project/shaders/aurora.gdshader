shader_type canvas_item;

uniform bool evil = false;

const vec3 good_color1 = vec3(0.5,1,0);
const vec3 good_color2 = vec3(0,1,0);
const vec3 good_color3 = vec3(0,0.8,0);

const vec3 bad_color1 = vec3(0.8,0,0);
const vec3 bad_color2 = vec3(0.9,0,0);
const vec3 bad_color3 = vec3(1,0,0);

void vertex() {
  // Animate Sprite moving in big circle around its location
  //VERTEX += vec2(0, sin(TIME)*100.0 + UV.x);
}

vec3 colour_gradient(float x) {
	// Pick a point in a 3-way triangular gradient.
	x = mod(x, 1); // Take fractional value, just in case
	if (evil) {
		if (x <= 0.333){
			return bad_color1 + x*(bad_color2 - bad_color1);
		} else if (x <= 0.666) {
			return bad_color2 + x*(bad_color3 - bad_color2);
		} else {
			return bad_color3 + x*(bad_color1 - bad_color3);
		}
	} else {
		if (x <= 0.333){
			return good_color1 + x*(good_color2 - good_color1);
		} else if (x <= 0.666) {
			return good_color2 + x*(good_color3 - good_color2);
		} else {
			return good_color3 + x*(good_color1 - good_color3);
		}
	}
}

void fragment(){
  // Offset for position shimmering
  float fac = 0.5;
  if (evil) {
	fac = 0.5;
  }
  vec2 offset = vec2(0, sin(TIME*fac + (SCREEN_UV.x*10.0))*0.02);

  // set colour
  COLOR = vec4(colour_gradient(mod(TIME*0.2,1)),texture(TEXTURE, UV + offset).a);
}