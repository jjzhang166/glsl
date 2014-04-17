#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float white;
    vec4 color;
    vec2 plasmaloc;
	vec2 location = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
    plasmaloc.x = location.x + cos(time * 0.1)*10.0;
    plasmaloc.y = location.y + sin(time * 0.1) * 7.0;
    plasmaloc /= 5.0;

    //Jonkinlainen plasmaefektilasku
    white = sin(plasmaloc.x) * sin(plasmaloc.y) * 2.5
          + sin(plasmaloc.x*(2.0 + 5.0*cos(plasmaloc.y*5.0))) * 1.5
          + sin(plasmaloc.y*(3.0 + 7.0*cos(plasmaloc.x*3.0))) * 1.5;

    white = abs(sin(white));

    //Määritellään fragmentin lopullinen väri
    color.x = (1.0 - white) * abs(sin(plasmaloc.y));
    color.y = white;
    color.z = 0.5 - 0.5 * white + 0.5;
    color.w = 1.0;

    //Kerrotaan vielä OpenGL:lle väri...

    gl_FragColor  = color;
}