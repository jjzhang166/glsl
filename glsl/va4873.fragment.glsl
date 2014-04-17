// Vlt / Dfm 
// Grid function from here: http://www.cs.uaf.edu/2010/spring/cs481/section/2/lecture/04_13_procedural.html
// replaced texture2D with noise function, then played around a bit.


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float grid(vec2 loc) {
	float dist=0.6; // distance to closest grid cell
	vec2 gridcorner=floor(loc);
	for (float dy=-1.0;dy<=1.0;dy++)
		for (float dx=-1.0;dx<=1.0;dx++)
		{
			vec2 thiscorner=gridcorner+vec2(dx,dy);
			vec2 delta = loc - thiscorner;
			float d = abs(delta.x)+abs(delta.y);
			dist=min(d,dist);
		}
	return dist;
}

vec3 hsv(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.y )*2.0)-1.0;
	
	// get cellular
	float c=grid(position*2.0);
	gl_FragColor = vec4(hsv(sin(c*time/-time*3.0+time)*.5+.5,1.,1.),1.);
}