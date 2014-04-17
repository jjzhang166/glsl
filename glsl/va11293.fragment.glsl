#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 c = (( gl_FragCoord.xy / resolution.xy ) - vec2(.5,.5)) * 3.; // from http://thndl.com/?5

	mat3 rotm = mat3(1.,0.,1.,  1.,sin(time),1., 1.,1.,1.); // rotation matrix, in theory...
rotm = mat3(
   1., 2.1, 2., 
   1., 2. * sin(time) +1. , 3.2, 
   1.3, 2., 2.3  
);
	
	c = (vec3(c,1.) * rotm).xy;

	
	float r=length(max(abs(c.xy)-.3,0.));
	gl_FragColor = vec4(r,r,r,1.);

}