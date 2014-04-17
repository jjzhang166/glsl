
varying highp vec2 surfacePosition;
uniform highp float time;
highp float radius = 0.1;

void main()
{

    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0) * sin(surfacePosition.x) * sin(time);
}