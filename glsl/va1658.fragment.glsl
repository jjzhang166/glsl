#ifdef GL_ES
precision mediump float;
#endif

// 2d shader nyan cat WIP
// a port from dl.dropbox.com/u/6213850/WebGL/nyanCat/nyan.html
// @blurspline

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



bool inPixel(vec2 cursor, vec2 group, vec2 position,  vec2 size) {
	return (
		(abs(position.x + size.x / 2.0 + group.x - cursor.x)<size.x) &&
		 (abs(position.y + size.y / 2.0 + group.y - cursor.y)<size.y)
	);
}

vec2 poptart = vec2(-10.5, 9.0);
vec2 feet = vec2(-12.5, -6.0);
vec2 tail = vec2(-16.5, 2.0);
vec2 face = vec2(-0.5, 4.0); //4.0

void main( void ) {

	//vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	float aspect = resolution.x / resolution.y;
	vec2 coords = gl_FragCoord.xy - resolution.xy/2.0 ; /// 2.0 - gl_FragCoord.xy resolution.xy 
	coords *= aspect;
	coords /= 8.0;
	
	vec3 color = vec3(0.0, 0.1875, 0.375);

	//POPTART
	if (inPixel( coords, poptart, vec2(0.0, -2.0), vec2(21.0, 14.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, poptart, vec2(1.0, -1.0), vec2(19.0, 16.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, poptart, vec2(2.0, 0.0), vec2(17.0, 18.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, poptart, vec2(1.0, -2.0), vec2(19.0, 14.0))) {
		color = vec3(1.0, 0.8, 0.6);
	}
	if (inPixel( coords, poptart, vec2(2.0, -1.0), vec2(17.0, 16.0))) {
		color = vec3(1.0, 0.8, 0.6);
	}
	if (inPixel( coords, poptart, vec2(2.0, -4.0), vec2(17.0, 10.0))) {
		color = vec3(1.0, 0.6, 1.0);
	}
	if (inPixel( coords, poptart, vec2(3.0, -3.0), vec2(15.0, 12.0))) {
		color = vec3(1.0, 0.6, 1.0);
	}
	if (inPixel( coords, poptart, vec2(4.0, -2.0), vec2(13.0, 14.0))) {
		color = vec3(1.0, 0.6, 1.0);
	}
	if (inPixel( coords, poptart, vec2(4.0, -4.0), vec2(1.0, 1.0))) {
		color = vec3(1.0, 0.2, 0.6);
	}
	if (inPixel( coords, poptart, vec2(9.0, -3.0), vec2(1.0, 1.0))) {
		color = vec3(1.0, 0.2, 0.6);
	}
	if (inPixel( coords, poptart, vec2(12.0, -3.0), vec2(1.0, 1.0))) {
		color = vec3(1.0, 0.2, 0.6);
	}
	if (inPixel( coords, poptart, vec2(16.0, -5.0), vec2(1.0, 1.0))) {
		color = vec3(1.0, 0.2, 0.6);
	}
	if (inPixel( coords, poptart, vec2(8.0, -7.0), vec2(1.0, 1.0))) {
		color = vec3(1.0, 0.2, 0.6);
	}
	if (inPixel( coords, poptart, vec2(5.0, -9.0), vec2(1.0, 1.0))) {
		color = vec3(1.0, 0.2, 0.6);
	}
	if (inPixel( coords, poptart, vec2(9.0, -10.0), vec2(1.0, 1.0))) {
		color = vec3(1.0, 0.2, 0.6);
	}
	if (inPixel( coords, poptart, vec2(3.0, -11.0), vec2(1.0, 1.0))) {
		color = vec3(1.0, 0.2, 0.6);
	}
	if (inPixel( coords, poptart, vec2(7.0, -13.0), vec2(1.0, 1.0))) {
		color = vec3(1.0, 0.2, 0.6);
	}
	if (inPixel( coords, poptart, vec2(4.0, -14.0), vec2(1.0, 1.0))) {
		color = vec3(1.0, 0.2, 0.6);
	}
	//FEET
	if (inPixel( coords, feet, vec2(0.0, -2.0), vec2(3.0, 3.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, feet, vec2(1.0, -1.0), vec2(3.0, 3.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, feet, vec2(1.0, -2.0), vec2(2.0, 2.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, feet, vec2(2.0, -1.0), vec2(2.0, 2.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, feet, vec2(6.0, -2.0), vec2(3.0, 3.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, feet, vec2(6.0, -2.0), vec2(4.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, feet, vec2(7.0, -2.0), vec2(2.0, 2.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, feet, vec2(16.0, -3.0), vec2(3.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, feet, vec2(15.0, -2.0), vec2(3.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, feet, vec2(15.0, -2.0), vec2(2.0, 1.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, feet, vec2(16.0, -3.0), vec2(2.0, 1.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, feet, vec2(21.0, -3.0), vec2(3.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, feet, vec2(20.0, -2.0), vec2(3.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, feet, vec2(20.0, -2.0), vec2(2.0, 1.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, feet, vec2(21.0, -3.0), vec2(2.0, 1.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	//TAIL
	if (inPixel( coords, tail, vec2(0.0, 0.0), vec2(4.0, 3.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, tail, vec2(1.0, -1.0), vec2(4.0, 3.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, tail, vec2(2.0, -2.0), vec2(4.0, 3.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, tail, vec2(3.0, -3.0), vec2(4.0, 3.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, tail, vec2(1.0, -1.0), vec2(2.0, 1.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, tail, vec2(2.0, -2.0), vec2(2.0, 1.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, tail, vec2(3.0, -3.0), vec2(2.0, 1.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, tail, vec2(4.0, -4.0), vec2(2.0, 1.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	//FACE
	if (inPixel( coords, face, vec2(2.0, -3.0), vec2(12.0, 9.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(0.0, -5.0), vec2(16.0, 5.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(1.0, -1.0), vec2(4.0, 10.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(11.0, -1.0), vec2(4.0, 10.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(3.0, -11.0), vec2(10.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(2.0, 0.0), vec2(2.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(4.0, -2.0), vec2(2.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(12.0, 0.0), vec2(2.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(10.0, -2.0), vec2(2.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(1.0, -5.0), vec2(14.0, 5.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, face, vec2(3.0, -4.0), vec2(10.0, 8.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, face, vec2(2.0, -1.0), vec2(2.0, 10.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, face, vec2(12.0, -1.0), vec2(2.0, 10.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, face, vec2(4.0, -2.0), vec2(1.0, 2.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, face, vec2(5.0, -3.0), vec2(1.0, 1.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, face, vec2(11.0, -2.0), vec2(1.0, 2.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	if (inPixel( coords, face, vec2(10.0, -3.0), vec2(1.0, 1.0))) {
		color = vec3(0.6, 0.6, 0.6);
	}
	//Eyes
	if (inPixel( coords, face, vec2(4.0, -6.0), vec2(2.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(11.0, -6.0), vec2(2.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(3.99, -5.99), vec2(1.01, 1.01))) {
		color = vec3(1.0, 1.0, 1.0);
	}
	if (inPixel( coords, face, vec2(10.99, -5.99), vec2(1.01, 1.01))) {
		color = vec3(1.0, 1.0, 1.0);
	}
	//MOUTH
	if (inPixel( coords, face, vec2(5.0, -10.0), vec2(7.0, 1.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(5.0, -9.0), vec2(1.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(8.0, -9.0), vec2(1.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	if (inPixel( coords, face, vec2(11.0, -9.0), vec2(1.0, 2.0))) {
		color = vec3(0.1333, 0.1333, 0.1333);
	}
	//CHEEKS
	if (inPixel( coords, face, vec2(2.0, -8.0), vec2(2.0, 2.0))) {
		color = vec3(1.0, 0.6, 0.6);
	}
	if (inPixel( coords, face, vec2(13.0, -8.0), vec2(2.0, 2.0))) {
		color = vec3(1.0, 0.6, 0.6);
	}
	
	gl_FragColor = vec4( color, 1.0 );

}