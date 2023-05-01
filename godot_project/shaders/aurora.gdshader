shader_type canvas_item;

uniform bool evil = false;


const vec3 good_color1 = vec3(0.7,1,0);
const vec3 good_color2 = vec3(0,1,0);
const vec3 good_color3 = vec3(0,1,0.5);

const vec3 bad_color1 = vec3(0.8,0,0);
const vec3 bad_color2 = vec3(1,0.4,0);
const vec3 bad_color3 = vec3(1,0,0.4);

void vertex() {
  // Animate Sprite moving in big circle around its location
  //VERTEX += vec2(0, sin(TIME)*100.0 + UV.x);
}

vec3 colour_gradient(float x) {
	// Pick a point in a 3-way triangular gradient.
	x = mod(x, 1); // Take fractional value, just in case
	if (evil) {
		if (x <= 0.333){
			return bad_color1 + (3.0*x)*(bad_color2 - bad_color1);
		} else if (x <= 0.666) {
			return bad_color2 + (3.0*x - 1.0) *(bad_color3 - bad_color2);
		} else {
			return bad_color3 + (3.0*x - 2.0)*(bad_color1 - bad_color3);
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
  float offset_y = sin(TIME*0.3 + (SCREEN_UV.x*10.0))*0.02;
  float offset_x = sin(TIME*1.0 + (SCREEN_UV.y*50.0))*0.0025;
  vec2 offset = vec2(offset_x, offset_y);

  // set colour
  COLOR = vec4(colour_gradient(mod(TIME*0.05,1)),texture(TEXTURE, UV + offset).a);
}