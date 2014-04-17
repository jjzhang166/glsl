precision lowp float;
uniform vec2 resolution;

void 
main(
)
{
	gl_FragColor= gl_FragCoord.y/resolution.y > ( 4.0 / 4.0 * 0.5) ? vec4 (777.0) : vec4(1.0, 0.0, 0.0, 1.0 * 77777.0);
}