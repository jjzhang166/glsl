//by @mrdoob, @IndialanJones
//mod ToBSn

//bearing little resemblance to OG. - gtoledo
//yay kalied - gt
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	
	

	
	 vec2 position = (-1.0 + 2.0 * gl_FragCoord.xy / resolution.xy);

   
    float a = atan(position.y,position.x);
    float r = sqrt(dot(position,position));

    position.x =          7.0*a/3.1416;
    position.y = -time+ sin(7.0*r+time) + .7*cos(time+7.0*a);

    float w = .5+.5*(sin(time+7.0*r)+ .7*cos(time+7.0*a));
	
	float t = 8.;
	//float color = 0.0;
	float color = sin( position.x * cos( t / 4.0 ) * 50.0 ) ;//+ cos( position.y * cos( t / 4.0 ) * sin(time*.1)+1. );
	color *= sin( position.y * sin( t / 4.0 ) * 20.0 ) + cos( position.x * sin( t / 4.0 ) * cos(time*.2)+1. );
	color *= sin( position.x * tan( t / 4.0 ) * 20.0 ) + sin( position.y * sin( t / 4.0 ) * (time+270.)/50.);
	color -= sin( t / 2.0 );

	color /= 0.01;
	color *=w;
	
	float c1 = smoothstep(1.0, color, 5.);
	float c2 = smoothstep(color, 1.0, 20.);
	float c3 = c1 + c2;

	gl_FragColor = vec4( vec3( c3, c3, c3 ), 1.0 );

}