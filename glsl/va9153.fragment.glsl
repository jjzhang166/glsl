#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.141592653589793
#define PI2 6.283185307179586

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5,0.5);

	float daytime = mod(time,2.0)/2.0;
	float dayrot = daytime*PI2; //(p.x+0.5)*PI2;
	
	float sx = 0.5+0.5*sin(p.x*PI2);
	float cx = 0.5+0.5*cos(p.x*PI2);
	float sy = 0.5+0.5*sin(p.y*PI2);
	float cy = 0.5+0.5*cos(p.y*PI2);
	float st = 0.5+0.5*sin(dayrot);
	float ct = 0.5+0.5*cos(dayrot);
	
	float n = ct*st;
	
	float s = max(max((0.5-n),0.0)* (cos(sx*sy*1000.0*st)*cos(cy*cx*1000.0*ct)),0.0);
	n = n*n;
	
	float r = sqrt(0.5*st*st)*n + s;
	float g = sqrt(0.25*ct*ct)*n + s;
	float b = ((1.0-(st-ct))-(ct*st)) * n;
	
	gl_FragColor = vec4( vec3( r, g, b ), 1.0 );

}