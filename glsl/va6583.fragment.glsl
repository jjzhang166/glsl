#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Trippy ~MrOMGWTF

vec3 Hue(float H)
{
	H *= 6.;
	return clamp(vec3(
		abs(H - 3.) - 1.,
		2. - abs(H - 2.),
		2. - abs(H - 4.)
	), 0., 1.);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy  *2.0) - 1.0;
	vec3 color = vec3(0.0);
	float z = 1.0 / (position.y + sin(position.x * sin(time * 0.5)) + sin(time) * 0.4 );
	float x = fract(time * 0.2) * 10.0;
	float r = -(clamp(x-3.0,0.0,1.0)+clamp(-x+1.0,0.0,1.0))+1.0 -(clamp(x-9.0,0.0,1.0)+clamp(-x+7.0,0.0,1.0))+1.0;
	float g = -(clamp(x-5.0,0.0,1.0)+clamp(-x+3.0,0.0,1.0))+1.0;
	float b = -(clamp(x-7.0,0.0,1.0)+clamp(-x+5.0,0.0,1.0))+1.0;
	color = pow(vec3(sin(position.x * 20.0 * z)
		    * (1.0 / z * 0.50))
		    * 2.3
		    * vec3(r,g,b)
		    * max(0.0, 1.0 - length(position * 0.7))
		    , vec3(1.0 / 2.2)) ;
	gl_FragColor = vec4( color, 1.0 );

}