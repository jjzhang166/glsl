#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//Nothing fancy :/
//Just another Julia

void main( void ) {

    vec2 position = (3.+0.5*sin(time*0.5))*( gl_FragCoord.xy / resolution.xy -0.5);
    float x = position.x;
    float y = position.y;
    
    for(int i = 0; i < 100; i++)
    {
        float x_ = x*x*x - y*y*x -2.*x*y*y + mouse.x*2.-1.0;
        float y_ = 2.*x*x*y+x*x*y-y*y*y +mouse.y*2.-1.;
        x = x_;
        y = y_;
        if(sqrt(x*x+y*y)>2.)
        {
            gl_FragColor = vec4(0.75*abs(sin(float(i))), 0.4*abs(sin(0.5+0.5*float(i))), 0.018*float(i), 1.);
            break;
        }
    }
    if(sqrt(x*x+y*y)<2.)
    {
        gl_FragColor = vec4(0., 0., 0., 1.);
    }

}