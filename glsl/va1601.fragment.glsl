/* Following iQ live coding tutorial on writing a basic raytracer http://www.youtube.com/watch?v=9g8CdctxmeU
 * @blurspline  ... this forked version mostly just scrunched up to fit in less space without obfuscating too much.  */
#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );  // this is the pixel coords
	vec3 proba = vec3(0.1);
	if (uv.x<0.5)
		proba=vec3(0.5);
		if (uv.y<0.5)
			proba=vec3(0.7);
	else
		if (uv.y<0.5)
			proba=vec3(0.3);
	gl_FragColor = vec4( proba, 1.0 );

}