package io.jenkins.mobile.example.myfirstbuiltbyjenkinsapplication

import androidx.test.platform.app.InstrumentationRegistry

import org.junit.jupiter.api.Test
import org.junit.runner.RunWith

import org.junit.Assert.*
import org.junit.jupiter.api.Assertions

/**
 * Instrumented test, which will execute on an Android device.
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
class ExampleInstrumentedTest {
    @org.junit.jupiter.api.Test
    fun useAppContext() {
        // Context of the app under test.
        val appContext = InstrumentationRegistry.getInstrumentation().targetContext
        Assertions.assertEquals(
            "io.jenkins.mobile.example.myfirstbuiltbyjenkinsapplication",
            appContext.packageName
        )
    }
}