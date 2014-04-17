
#ifdef GL_ES
precision highp float;
#endif
//gt
uniform float time;
uniform vec2 resolution;


void main( void ) {
   
	vec2 p = gl_FragCoord.xy / resolution;

	float a = mod(p.x,1.0/12.)*8.;
	float b = sin(gl_FragCoord.x/10.+time);
	float c = cos(gl_FragCoord.y/4.+time);
	vec3 clr = vec3(pow((a*c)*7.,1.-b));
	clr.r+=sin(gl_FragCoord.x+time);
	clr.g+=sin(gl_FragCoord.x+time+2.);
	clr.b+=sin(gl_FragCoord.x+time+4.);
    	gl_FragColor = vec4(1.-clr, 1.0);

}