
varying highp vec2 surfacePosition;
uniform highp float time;
highp float radius = 0.1;

void main()
{

    gl_FragColor = vec4(
                    mod(sin(tan(surfacePosition.x * surfacePosition.y) * sin(time)), radius), 
                    mod(cos(tan(surfacePosition.x * surfacePosition.y)), radius), 
                    mod(tan(cos(sin(surfacePosition.x * surfacePosition.y))), radius), 
                    1.0) * 5.0;
}
