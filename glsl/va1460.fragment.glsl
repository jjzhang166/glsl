#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// removed simplex noise here and added something shorter to play with:
float not_snoise(vec3 v) {	return( sin(v.x) + sin(v.z) + sin(v.z) + mouse.x-mouse.y);  }

vec3 nc(vec2 a, float f){
	float x = a.x;
	float y = a.y;
	x *= f;
	y *= f;
	float z = time*0.01*f;
	x += z*2.0;
	y += z*2.0;
	
	float x2 = x;
	float y2 = y*0.8-z*0.6;
	float z2 = z*0.8+y*0.5;
	
	float b = not_snoise(vec3(x2,y2,z2));
	
	return vec3(
		b+(fract(f*0.245325435)-0.5)*0.01,
		b+(fract(f*0.174534534)-0.5)*0.1,
		b+(fract(f*0.724342356)-0.5)*0.1
	)+1.0;
}

void main( void ) {
	vec2 position = vec2( gl_FragCoord.x / resolution.x - 0.5, (gl_FragCoord.y - resolution.y * 0.5) / resolution.x );
	vec3 c1 = nc(position, 3.0);
	vec3 c2 = nc(vec2(position.x*0.5-position.y*0.85, position.y*0.5+position.x*0.85), 5.0);
	vec3 c3 = nc(vec2(position.x*0.5+position.y*0.85, position.y*0.5-position.x*0.85), 8.0);
	vec3 c4 = nc(vec2(position.x*0.8+position.y*0.6, position.y*0.8-position.x*0.6), 13.0);
	vec3 c5 = nc(vec2(position.x*0.8-position.y*0.6, position.y*0.8+position.x*0.6), 21.0);
	vec3 c6 = nc(vec2(-position.x*0.8+position.y*0.6, -position.y*0.8-position.x*0.6), 34.0);
	vec3 c7 = nc(vec2(-position.x*0.8-position.y*0.6, -position.y*0.8+position.x*0.6), 55.0);

	vec3 ca = max(max(max(c1,c2),max(c3,c4)),max(max(c5, c6), c7));
	vec3 cb = max(max(max(sign(ca-c1)*c1,sign(ca-c2)*c2),max(sign(ca-c3)*c3,sign(ca-c4)*c4)),max(max(sign(ca-c5)*c5,sign(ca-c6)*c6),sign(ca-c7)*c7));
	vec3 cc = max(max(max(sign(cb-c1)*c1,sign(cb-c2)*c2),max(sign(cb-c3)*c3,sign(cb-c4)*c4)),max(max(sign(cb-c5)*c5,sign(cb-c6)*c6),sign(cb-c7)*c7));
	vec3 cd = max(max(max(sign(cc-c1)*c1,sign(cc-c2)*c2),max(sign(cc-c3)*c3,sign(cc-c4)*c4)),max(max(sign(cc-c5)*c5,sign(cc-c6)*c6),sign(cc-c7)*c7));

	gl_FragColor = vec4(cd-0.5, 1.0 );
}


