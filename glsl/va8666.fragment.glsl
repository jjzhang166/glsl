#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy ) ;

	vec3 dir = normalize ( vec3(uv*uv.x,0.05) );
	

	vec3 c = vec3(0.0);
	
	
	if ( dir.x * dot( dir, dir * 2.0 ) > 0.5 && dir.x < 0.5 )
	{
		c = vec3(dir.x+dir.y);
	}
	else if ( dir.y > 0.5 && dir.y < 0.7 )
	{
		c.r = 1.0;
	}
	else if( dir.y * dot(dir,dir) < 0.5 )
	{
		c.b =1.0;
	}
	
	
	if( dir.x + dir.y > dot(dir,dir*dir) ) {
	
		c.g = 1.0;
		

	}
	
	
	if( dot( dir, vec3 ( 1.1, 0.8, -0.5 ) ) > 0.9 ){
		c=vec3(1.0,0.0,1.0);
		
	}
	
	vec3 _reflected = reflect ( dir, vec3(max(sin(time*5.0),0.1)*0.2, 0.05, 1.1005 ) );
	
	c *= _reflected.r;
	
	c += pow ( dot( dir, _reflected), 32.0 ) + dir;
	
	gl_FragColor = vec4( c, 2.0 );

}