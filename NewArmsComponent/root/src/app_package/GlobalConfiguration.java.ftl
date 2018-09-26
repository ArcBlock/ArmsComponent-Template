package ${packageName}.app;

import android.app.Application;
import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;

import com.jess.arms.base.delegate.AppLifecycles;
import com.jess.arms.di.module.GlobalConfigModule;
import com.jess.arms.integration.ConfigModule;
import com.jess.arms.utils.ArmsUtils;
import com.squareup.leakcanary.RefWatcher;

import java.util.List;

import ${packageName}.BuildConfig;

/**
 * ================================================
 * Set Component global config here, and need add this class to AndroidManifest
 * AppCommonSDK has already set some config in GlobalConfiguration
 * This config just add some private config of itself.
 *
 * @see com.jess.arms.base.delegate.AppDelegate
 * @see com.jess.arms.integration.ManifestParser
 * @see <a href="https://github.com/JessYanCoding/ArmsComponent/wiki#3.3">ConfigModule wiki 官方文档</a>
 * Created by ArmsComponentTemplate
 * ================================================
 */
public final class GlobalConfiguration implements ConfigModule {

    @Override
    public void applyOptions(Context context, GlobalConfigModule.Builder builder) {

    }

    @Override
    public void injectAppLifecycle(Context context, List<AppLifecycles> lifecycles) {
        // All methods of AppLifecycles are called during the corresponding life cycle of the base class Application, 
        // so you can extend some of the logic you need in the corresponding methods
        // You can add multiple implementation classes based on different logic 
        lifecycles.add(new AppLifecyclesImpl());
    }

    @Override
    public void injectActivityLifecycle(Context context, List<Application.ActivityLifecycleCallbacks> lifecycles) {

    }

    @Override
    public void injectFragmentLifecycle(Context context, List<FragmentManager.FragmentLifecycleCallbacks> lifecycles) {
        //when moudule integrate to the App, the App has already perform the code
        if (BuildConfig.IS_BUILD_MODULE) {
            lifecycles.add(new FragmentManager.FragmentLifecycleCallbacks() {
                @Override
                public void onFragmentDestroyed(FragmentManager fm, Fragment f) {
                    ((RefWatcher) ArmsUtils
                            .obtainAppComponentFromContext(f.getActivity())
                            .extras()
                            .get(RefWatcher.class.getName()))
                            .watch(f);
                }
            });
        }
    }
}
