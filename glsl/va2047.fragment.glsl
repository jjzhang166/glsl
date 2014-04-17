// If you're going to do a strobe, do it right.

// Fixed it to make it right.

// Even more right :)

uniform sampler2D backbuffer;
void main(void){gl_FragColor = 1.-texture2D(backbuffer, vec2(0));}