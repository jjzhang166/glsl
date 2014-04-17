#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// "it"  inverse transform
// "pos" position
// "cen" center

vec2 it_stretch(vec2,vec2,float);
vec2 it_rotate(vec2, vec2, float);
vec2 it_polygon_stretch(vec2, vec2, int, float);
vec4 color_by_position_polygon(vec2, vec2, int);

float twoPI;
vec3 t;

void main( void ) {
	twoPI = 4.0 * atan(1.0,0.0);
	
	vec2 pos = ( gl_FragCoord.xy - resolution.xy*0.5 )/ resolution.xx;
	vec2 cen = vec2(0);
	float r = length(pos);
	t = 0.5*vec3(time, sin(time), sin(1.2*time));
	pos = it_rotate(pos, cen, 0.2*t.x+t.y+10.0*t.z*r);
	pos = it_stretch(pos, cen, 2.0+t.z);
	cen += 0.3*vec2(t.y,t.z);
	gl_FragColor = color_by_position_polygon(pos.xy, cen, 3);

}

vec2 it_stretch(vec2 pos, vec2 center, float factor){
	vec2 d = pos-center;
	return center + d / factor;
}

vec2 it_rotate(vec2 pos, vec2 center, float alpha){
	vec2 d = pos-center;
	return vec2(cos(alpha)*d.x - sin(alpha)*d.y, sin(alpha)*d.x + cos(alpha)*d.y);
}

vec2 it_polygon_stretch(vec2 pos, vec2 center, int N, float factor){
	vec2 d = pos-center;
	float n = float(N);
	float angle = atan(d.y, d.x);
	float section_angle = ( floor(n * angle / twoPI) + 0.5 ) * twoPI / n;
	vec2 section_direction = vec2(cos(section_angle), sin(section_angle));
	d = section_direction * dot(section_direction, d);
	return pos + d * (1.0 - 1.0 / factor);
}

vec4 color_by_position_polygon(vec2 pos, vec2 center, int N){
	float r;
	if(N==0)r = length(pos);
	else{
		vec2 d = pos-center;
		float n = float(N);
		float angle = atan(d.y, d.x);
		float section_angle = ( floor(n * angle / twoPI) + 0.5 ) * twoPI / n;
		r = cos(section_angle)*d.x + sin(section_angle)*d.y;
	}
	float angle = atan(pos.y, pos.x);
	r+=0.01*sin(angle+t.x)*cos(angle+t.z)*(t.y + 2.0);
	return vec4(fract(vec3(11.0,21.0,37.0)*sqrt(r)+t.x*0.2+t.y*0.5),1.0);
}