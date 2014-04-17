#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 cal_color(float x, float y)
{
	float zr = 0.0,zi=0.0,cr=0.0,ci=0.0;
	float zrsq = 1.0;
	float zisq = 0.0;
	float c = 1.0;
	for(int a = 0; a < 10; a ++)
	{
		zi = zr * zi * 2.0 + ci;
		zr = zrsq - zisq + cr;
		zrsq = zr * zr;
		zisq = zi * zi;
		c = 0.0;
		if (zisq + zrsq > 4.0){
			int x = 1;
		}
		c = float(x);
		
	}
	return vec3(0,0,c);
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	gl_FragColor = vec4( cal_color(position.x,position.y), 1.0 );

}