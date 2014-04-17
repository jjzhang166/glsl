#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float blob(vec2 p, float px, float py)
{
	return (1.0 / distance(p,vec2(px,py)))*0.05;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;

	float mBlobX = 0.5+sin(time)*0.5;
	
	color += blob(position, mBlobX, 0.5);
	color += blob(position, mBlobX+sin(time)*0.05,0.5);
	color += blob(position, mBlobX+sin(time)*0.1,0.5+sin(time)*0.1);
	color += blob(position, mBlobX+sin(time)*0.2,0.5+sin(time)*0.2);
	color += blob(position, mBlobX+sin(time)*0.3,0.5+sin(time)*0.3);
	color += blob(position, mBlobX+sin(time)*0.4,0.5+sin(time)*0.4);

	
	gl_FragColor = vec4( vec3( color*0.5, color*1.0, color*1.0), 1.0 );

}