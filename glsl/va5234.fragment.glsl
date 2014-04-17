#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//simple brick scene
//intended to be scaled with nearest neighbour filtering
//mattdesl - http://devmatt.wordpress.com/

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

float sigmoid(float x) {
	return 2./(1. + exp2(-x)) - 1.;
}

float smoothcircle(vec2 uv, float radius, float sharpness){
	return 0.5 - sigmoid( ( length( (uv - 0.5)) - radius) * sharpness) * 0.5;
}

void main( void ) {
	vec2 aspect = vec2(1.,resolution.y/resolution.x);

	vec2 position = 0.5 + (gl_FragCoord.xy * vec2(1./resolution.x,1./resolution.y) - 0.5)*aspect;;
	
	float filter = smoothcircle(position-(0.5 + (mouse-0.5)*aspect) +0.5, 0.15, 64.);

	float bw = 30.0;
	float bh = 10.0;
	float lw = 1.0;
	float x = position.x*resolution.x;
	float y = position.y*resolution.y;
	float bx = mod(position.y*resolution.y, bh*2.0) < bh ? x + bw/2.0 : x;
	
	float xbw = mod(bx, bw);
	float ybh = mod(y, bh);
	float TW = resolution.x/bw;
	float TH = resolution.y/bh;
	
	vec3 N = vec3(0.0, 0.0, 1.0);
	
	//bit of faux randomization
	float xpos = floor(mod(bx/bw, TW));
	float ypos = floor(mod(y/bh, TH));
	vec3 color = vec3(.25 + rand(vec2(xpos, ypos))*.25);
	color.r += .0;
	color.g += .0;
	color.b += .5;
	
	//mortar
	if ( mod(y+lw, bh) < lw || mod(bx, bw) < lw ) {
		color = vec3(0.95);	
	} 
	//brick
	else {
		color.r += 0.05;
	}
	//floor
	if ( (y+1.0)/bh < 4.0 ) {
		color = vec3(0.5);
	}
	color -= rand(position.xy)*.09;
	
	
	
	gl_FragColor = vec4(color*filter, 15);
}