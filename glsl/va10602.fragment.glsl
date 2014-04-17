//by @kindofsleepy
 
#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
 
 
float multiplyer(float param){
    float var = 1.0;
	
     
    var += cos(time*resolution.y)*0.03;
  		
	
    return var;
}
 
vec2 split(vec2 param){
 
	
	param.x += param.x/param.y;
	param.y += param.y+param.x;
	
	param.y += sin(20.0)*2.0;
	
	return param;
	
}
void main( void ) {
 
	vec2 position = ( gl_FragCoord.xy / resolution.xy )-sin(multiplyer(resolution.x)/50.0);
	
	position = split(position);
	position.x -= multiplyer(200.0)/50.0;
 
	
	
	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;
 
	gl_FragColor = vec4( vec3( color*sin(multiplyer(time)), color * 0.5, cos( color + time / 3.0 ) * 0.75 ), 1.0 );
 
}