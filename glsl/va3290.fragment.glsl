// WIP
// by rotwang, playing with barrel distortion

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float BarrelPower = 2.0;

// copied from Little Grasshopper
// Given a vec2 in [-1,+1], generate a texture coord in [0,+1]
vec2 barrel_distortion(vec2 p)
{
    float theta  = atan(p.y, p.x);
    float radius = length(p);
    radius = pow(radius, BarrelPower);
    p.x = radius * cos(theta);
    p.y = radius * sin(theta);
    return 0.5 * (p + 1.0);
}




void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution ); 
	vec2 pos = unipos *2.0-1.0;
	pos *= aspect;
	pos = barrel_distortion(pos);
	
	float n = 1.0/ 8.0;
	vec2 pm =  mod( pos, n);

	vec3 clr_a = vec3(pos-pm,0.5);
	vec3 clr_b = vec3(0.5, pos-pm);
	
	vec3 clr = mix(clr_a, clr_b, 0.5);
	
	gl_FragColor = vec4( clr, 1.0 );

}