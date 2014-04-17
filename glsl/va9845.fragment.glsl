#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 tex(vec2 position)
{
	// from http://glsl.heroku.com/e#8558.0
	float sum = 0.;
	float qsum = 0.;
	
	for (float i = 0.; i < 100.; i++) {
		float x2 = i*i*.3165+(250.*i*0.01)+.5;
		float y2 = i*.161235+(250.*i*0.01)+.5;
		vec2 p = (fract(position-vec2(x2,y2))-vec2(.5));
		float a = atan(p.y,p.x);
		float r = length(p)*100.;
		float e = exp(-r*.5);
		sum += sin(r+a+time)*e;
		qsum += e;
	}
	
	float color = sum/qsum;
	return step( 0.25, vec3( color, color-.5, -color ) );
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy )*2.0-1.0;
	
	vec2 sp = mouse-0.5;
	
	vec2 move = vec2(0.2,0.6);

	vec2 uv = vec2(p.x/abs(p.y)+time*move.x,1./(abs(p.y))+time*move.y);
	
	vec3 color = tex(uv*.1);
	color *= vec3(pow(p.y,0.75));
	
	gl_FragColor = vec4(color, 1.0 );

}