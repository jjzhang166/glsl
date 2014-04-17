#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	float pcolor = 0.0;
	
	float n = 8.;//number of rows and columns

	for(float i = 0.0;i < 1.0;i+=(1./8.))
	{
		for(float j = 0.0;j < 1.0;j+=(1./8.))
		{
			vec2 pp = vec2(i+(1./(n*2.)),j+(1./(n*2.)));
			
			pp.y += sin(time+i*77.0)*0.125;
			pp.x += sin(time-j*127.0)*0.125;
			
			pcolor = color;
			color = max(pow(1.-distance(pp,p),8.),pcolor);
		}
	}
	color = pow((1.-color)*1.5,4.);
	color = clamp(color,0.0,1.0);
	
	vec3 col = mix(color * vec3(0,1,1),vec3(1),color);

	gl_FragColor = vec4( vec3( col ), 1.0 );

}