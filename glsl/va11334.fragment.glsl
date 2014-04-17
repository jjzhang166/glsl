#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//Nothing fancy :/
//Just another Julia

void main( void ) {

    vec2 position = (4.)*( gl_FragCoord.xy / resolution.xy -0.5);
    float x = position.x;
    float y = position.y;
    
    for(int i = 0; i < 70; i++)
    {
        float x_ = x*x - y*y + mouse.x*2.-1.;
        float y_ = 2.*x*y +mouse.y*2.-1.;
        x = x_;
        y = y_;
        if(sqrt(x*x+y*y)>2.)
        {
            gl_FragColor = vec4(0.025*float(i), 0.01, 0.028*float(i), 1.);
	    gl_FragColor = vec4(1., 1., 1., 1.);
            break;
        }
    }
    if(sqrt(x*x+y*y)<2.)
    {
        gl_FragColor = vec4(0., 0., 0., 1.);
    }

}