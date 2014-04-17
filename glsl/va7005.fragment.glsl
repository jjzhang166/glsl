varying highp vec2 surfacePosition;
uniform highp float time;
highp float radius = 0.1;

void main()
{

    gl_FragColor = vec4(1.0, abs(sin(time)), abs(cos(time)), 1.0) * sin(surfacePosition.x * 90.0) * cos(surfacePosition.y * 90.0);
}