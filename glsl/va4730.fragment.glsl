// Vlt / Dfm 
// Grid function from here: http://www.cs.uaf.edu/2010/spring/cs481/section/2/lecture/04_13_procedural.html
// replaced texture2D with noise function, then played around a bit.


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 noise(vec2 n) {
	vec2 ret;
	ret.x=fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
	ret.y=fract(cos(dot(n.yx, vec2(34.9865, 65.946)))* 28618.3756);
	return ret;
}

float grid(vec2 loc) {
	float dist=10.; // distance to closest grid cell
	vec2 gridcorner=floor(loc);
	for (float dy=-1.0;dy<=1.0;dy++)
		for (float dx=-1.0;dx<=1.0;dx++)
		{
			vec2 thiscorner=gridcorner+vec2(dx,dy);
			vec2 gridshift=noise(thiscorner);
			if (gridshift.x>.5) gridshift.x = .8;else gridshift.x=0.2; // pick some weird grid offsets
			if (gridshift.y>.5) gridshift.y = .1;else gridshift.y=0.7; // pick some weird grid offsets
			vec2 center=thiscorner+gridshift;
			float radius=length(loc-center);
			dist=min(radius,dist);
		}
	return dist;
}

void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.y )*2.0)-1.0;
	
	// get cellular
	float c=grid(position*(5.0+4.0*sin(time)));
	
	// emphasize bright and dark
	c=pow(c*2.0,2.)*0.5;

	gl_FragColor = vec4(c*.9,c*.3,c*.2,1.0); //mix( col,c2,0.8), 1.0 );

}