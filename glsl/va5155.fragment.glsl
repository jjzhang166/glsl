#ifdef GL_ES
precision mediump float;
#endif

// pan/zoom MOD!

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
varying vec2 surfacePosition;

vec2 noise(vec2 n) {
	vec2 ret;
	ret.x=fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453)*2.0-1.0;
	ret.y=fract(sin(dot(n.xy, vec2(34.9865, 65.946)))* 28618.3756)*2.0-1.0;
	return normalize(ret);
}

float perlin(vec2 p) {
	vec2 q=floor(p);
	vec2 r=fract(p);
	float s=dot(noise(q),p-q);
	float t=dot(noise(vec2(q.x+1.0,q.y)),p-vec2(q.x+1.0,q.y));
	float u=dot(noise(vec2(q.x,q.y+1.0)),p-vec2(q.x,q.y+1.0));
	float v=dot(noise(vec2(q.x+1.0,q.y+1.0)),p-vec2(q.x+1.0,q.y+1.0));
	float Sx=3.0*(r.x*r.x)-2.0*(r.x*r.x*r.x);
	float a=s+Sx*(t-s);
	float b=u+Sx*(v-u);
	float Sy=3.0*(r.y*r.y)-2.0*(r.y*r.y*r.y);
	return a+Sy*(b-a);
}

float fbm(vec2 p, float f) {
	return perlin(p*f) + perlin(4.0*p*f)/4.0
		+ perlin(16.0*p*f)/16.0 + perlin(64.0*p*f)/64.0;
}

float ridge(float n) {
	return 0.5 - 2.0 * abs(n);
}

float fbmridge(vec2 p, float f) {
	return ridge(perlin(p*f)) + ridge(perlin(3.0*p*f))/2.0
		+ ridge(perlin(6.0*p*f))/4.0 + ridge(perlin(9.0*p*f))/8.0;
}

vec2 complex_div(vec2 numerator, vec2 denominator){
   return vec2( numerator.x*denominator.x + numerator.y*denominator.y,
                numerator.y*denominator.x - numerator.x*denominator.y)/
          vec2(denominator.x*denominator.x + denominator.y*denominator.y);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	//vec2 position = surfacePosition + vec2(0., 0.5);
	
	position = mix( 0.5 + (position- 0.5)*2., complex_div(vec2(0.025,.0), position - mouse) + 0.5, 0.5); 
	
	float conts = fbm(position, 5.0);
	conts = conts * min(max(position.y - 0.1, 0.0) * 4.0, 1.0);
	conts = conts * min((max(0.9 - position.y, 0.0)) * 2.0, 1.0);
	
	float height = fbmridge(position, 12.0) * (perlin(position * 5.0) + 0.5) + 0.5;
	height = (height * height * clamp(-conts + 0.1, 0.0, 1.0)) * 2.0;
	
	conts = step(conts, -0.03);
	
	vec3 landColor = vec3(0.0,1.0,0.0);
	if (height > 0.2) landColor = vec3(0.7,0.9,0.6);
	if (height > 0.3) landColor = vec3(1.0,1.0,1.0);
	if (height < 0.1) landColor = vec3(1.0,0.9,0.4) * 2.0;
	landColor *= (height + 0.3);
	
	vec3 color = conts == 0.0 ? vec3(0.0,0.0,0.7)
		                  : landColor;
	if (position.y < perlin(vec2(-position.x, 0.0) * 20.0) / 40.0 + 0.05 ||
	    position.y > perlin(vec2(position.x, 0.0) * 20.0) / 40.0 + 0.95)
		color = vec3(1.0);
	
	gl_FragColor = vec4(color, 1.0 );

}