#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D texture;

void main()
{
    vec2 p = gl_FragCoord.xy / vec4(800,600,0,0).xy;
	gl_FragColor = texture2D(texture, p);
 
    //if (gl_FragColor.a > 0.5) {
    //    gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
    //}else{
    //    gl_FragColor = vec4(0.0, 0.0, 0.5, 0.7);
    //}
}