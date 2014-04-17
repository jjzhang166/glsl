#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//using tutorial at http://lodev.org/cgtutor/tunnel.html
void getColorAt(in float x, in float y, out vec3 color)
{
	color = vec3(sin(x), 0.0, sin(y));
}

void main( void ) {

	//vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec3 color  = vec3(0.0, 0.0, 0.0);
	float angle, distance;
	float x, y, w, h;
	x = gl_FragCoord.x;
	y = gl_FragCoord.y;
	w = resolution.x;
	h = resolution.y;
	float realDistance = 32.0 * 255.0 / sqrt((x - w / 2.0) * (x - w / 2.0) + (y - h / 2.0) * (y - h / 2.0));
	distance = mod(realDistance, 255.0);
        angle = 128.0 * atan(y - h / 2.0, x - w / 2.0) / 3.1416;
	float animation = time*70.0;
	float shiftX = animation;
	float shiftY = .25*animation;
	getColorAt(mod(distance + shiftX, 255.0), mod(angle + shiftY, 255.0), color);
	color.x = color.x*(1.0/(realDistance*0.03));
	color.y = color.y*(1.0/(realDistance*.03));
	color.z = color.z*(1.0/(realDistance*.03));
	gl_FragColor = vec4(color, 0.0);
	//gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}