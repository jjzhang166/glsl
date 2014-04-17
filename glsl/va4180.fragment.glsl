#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
/*
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}
*/
// texcoords
//varying vec2 texcoord0;
//varying vec2 texcoord1;

// samplers
//uniform sampler2DRect tex0;
uniform sampler2D backbuffer;


const float timestep = 0.75;
const float spacestep = 1.;
const float damping = 0.05;
const float wavespeed = 0.5;


// entry point
void main()
{   
	float timeSpaceFactor = (timestep*timestep)/(spacestep*spacestep);
	float dampFactor = 1.0 - damping*timestep;
   
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 8.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	vec4 plasma = vec4( vec3( color, color , color ), 1.0 );

	vec4 t_0 = plasma;
	vec4 t_n1 = texture2D(backbuffer, position);
	
	float ds = spacestep;
	vec4 t00 = texture2D(backbuffer, position + vec2(-ds, -ds));
	vec4 t10 = texture2D(backbuffer, position + vec2(0., -ds));
	vec4 t20 = texture2D(backbuffer, position + vec2(ds, -ds));
	
	vec4 t01 = texture2D(backbuffer, position + vec2(-ds, 0.));
	vec4 t21 = texture2D(backbuffer, position + vec2(ds, 0.));
	
	vec4 t02 = texture2D(backbuffer, position + vec2(-ds, ds));
	vec4 t12 = texture2D(backbuffer, position + vec2(0., ds));
	vec4 t22 = texture2D(backbuffer, position + vec2(ds, ds));
	
	vec4 time = t_0 + dampFactor*(t_0 - t_n1);
	vec4 diag = 4.*t_0 - (t00 + t20 + t02 + t22);
	vec4 cross = 4.*t_0 - (t10 + t01 + t21 + t12);
	vec4 val = time - timeSpaceFactor*wavespeed*(cross + 0.5*diag);
	
	val = clamp(val, -1., 1.);

	gl_FragColor = val;
}