// @rotwang: @mod* scale with aspect, unipolar hue, radius change

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 mul(vec2 v,vec2 v2){
	return vec2((v.x*v2.x-v.y*v2.y),v.y*v2.x+v.x*v2.y);
}
vec2 add(vec2 v,vec2 v2){
	return vec2(v.x+v2.x,v.y+v2.y);
}

vec3 mandel(vec2 pos){
	vec2 c=vec2(-0.8,0.156);
	vec2 z=vec2((pos.x/resolution.x-0.5)*3.0,(pos.y/resolution.y-0.5)*2.0);
	
	for (float i=0.0;i<100.0;i++){
		z=add(mul(z,z),c);
		if ((z.x*z.x+z.y*z.y)>1000.0)
			return vec3(i/100.0,0,0);
	}
	return vec3(1,0,0);

	
}

void main( void ) {
	

	gl_FragColor = vec4(mandel(gl_FragCoord.xy),0);
	
}